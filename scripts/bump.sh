#!/usr/bin/env bash
# Points this tap at a release of klarluft/gitwarren-app - both the cask and
# the formula.
#
#   scripts/bump.sh            # the latest published, non-prerelease release
#   scripts/bump.sh v0.1.5     # a specific tag
#
# The cask is rewritten in place: both macOS disk images are downloaded, their
# SHA-256 sums computed, and the version and checksum lines replaced.
#
# The formula is not rewritten, it is REPLACED. `gitwarren-cli.rb` is built by
# the app repository's release workflow, which hashes the four daemon tarballs
# in the same run that uploads them - so the tap's job is to copy one file
# rather than to download a release at a second time and hash assets it has to
# hope are final. See scripts/build-homebrew-formula.mjs over there.
#
# That copy step did not exist until Sept 2026, which is why v0.1.7 shipped a
# generated formula that sat on the release while this tap had none at all and
# `brew install klarluft/tap/gitwarren-cli` was a "No available formula" for
# everyone who tried it.
#
# Everything downloaded is checked before anything on disk is touched, so a
# release this tap cannot be fully pointed at leaves a clean tree rather than a
# bumped cask beside a stale formula - which is the same bug in a new shape.
#
# Prints the version it landed on and exits 0 whether or not anything changed;
# the caller decides what to do with a diff. Needs `gh`, authenticated or not -
# the repository is public.
#
# Style note: `brew style` lints this script with shellcheck and shfmt under
# Homebrew's own config, so braced expansions and `[[ ]]` are required here.
set -euo pipefail

repo="klarluft/gitwarren-app"
root="$(cd "$(dirname "${0}")/.." && pwd)"
cask="${root}/Casks/gitwarren.rb"
formula="${root}/Formula/gitwarren-cli.rb"

tag="${1:-}"
if [[ -z ${tag} ]]
then
  tag="$(gh release list --repo "${repo}" --exclude-drafts --exclude-pre-releases \
    --limit 1 --json tagName --jq '.[0].tagName')"
fi
[[ -n ${tag} ]] || {
  echo "no published release found" >&2
  exit 1
}
version="${tag#v}"

work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

gh release download "${tag}" --repo "${repo}" --dir "${work}" \
  --pattern "GitWarren-${version}-arm64.dmg" \
  --pattern "GitWarren-${version}-x64.dmg" \
  --pattern "gitwarren-cli.rb"

# Validate the formula asset before the cask is touched. Every release from
# v0.1.7-beta.1 carries it; a tag that predates it is a tag this tap cannot be
# fully pointed at, and stopping here leaves nothing half-applied.
[[ -f ${work}/gitwarren-cli.rb ]] || {
  echo "release ${tag} has no gitwarren-cli.rb asset - this tap cannot be pointed at it" >&2
  exit 1
}

# A half-substituted template is the one failure that reaches a user as
# `SHA256 mismatch` with nothing on either end to explain it.
if grep -q '__[A-Z0-9_]*__' "${work}/gitwarren-cli.rb"
then
  echo "gitwarren-cli.rb from ${tag} still has unsubstituted placeholders" >&2
  exit 1
fi
grep -qF "version \"${version}\"" "${work}/gitwarren-cli.rb" || {
  echo "gitwarren-cli.rb from ${tag} does not declare version ${version}" >&2
  exit 1
}

sum() { shasum -a 256 "${1}" | cut -d' ' -f1; }
arm="$(sum "${work}/GitWarren-${version}-arm64.dmg")"
intel="$(sum "${work}/GitWarren-${version}-x64.dmg")"

# Anchored to the exact stanza shapes in the cask, so a stray match elsewhere
# cannot be rewritten by accident.
sed -i.bak -E \
  -e "s|^(  version \")[^\"]+(\")$|\1${version}\2|" \
  -e "s|^(  sha256 arm:   \")[0-9a-f]{64}(\",)$|\1${arm}\2|" \
  -e "s|^(         intel: \")[0-9a-f]{64}(\")$|\1${intel}\2|" \
  "${cask}"
rm -f "${cask}.bak"

# A silent sed miss would leave a cask that installs the old version under
# the new checksums, so confirm every value actually landed.
grep -qF "version \"${version}\"" "${cask}"
grep -qF "${arm}" "${cask}"
grep -qF "${intel}" "${cask}"

# Copied whole, now that the cask has landed and the asset is known good.
mkdir -p "$(dirname "${formula}")"
cp "${work}/gitwarren-cli.rb" "${formula}"

echo "gitwarren ${version}"
