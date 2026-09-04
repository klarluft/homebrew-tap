#!/usr/bin/env bash
# Points Casks/gitwarren.rb at a release of klarluft/gitwarren-app.
#
#   scripts/bump.sh            # the latest published, non-prerelease release
#   scripts/bump.sh v0.1.5     # a specific tag
#
# Downloads both macOS disk images from the release, computes their SHA-256
# sums, and rewrites the version and checksum lines in place. Prints the
# version it landed on and exits 0 whether or not anything changed; the caller
# decides what to do with a diff. Needs `gh`, authenticated or not — the
# repository is public.
set -euo pipefail

repo="klarluft/gitwarren-app"
cask="$(cd "$(dirname "$0")/.." && pwd)/Casks/gitwarren.rb"

tag="${1:-}"
if [ -z "$tag" ]; then
  tag="$(gh release list --repo "$repo" --exclude-drafts --exclude-pre-releases \
           --limit 1 --json tagName --jq '.[0].tagName')"
fi
[ -n "$tag" ] || { echo "no published release found" >&2; exit 1; }
version="${tag#v}"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

gh release download "$tag" --repo "$repo" --dir "$work" \
  --pattern "GitWarren-${version}-arm64.dmg" \
  --pattern "GitWarren-${version}-x64.dmg"

sum() { shasum -a 256 "$1" | cut -d' ' -f1; }
arm="$(sum "$work/GitWarren-${version}-arm64.dmg")"
intel="$(sum "$work/GitWarren-${version}-x64.dmg")"

# Anchored to the exact stanza shapes in the cask, so a stray match elsewhere
# cannot be rewritten by accident.
sed -i.bak -E \
  -e "s|^(  version \")[^\"]+(\")$|\1${version}\2|" \
  -e "s|^(  sha256 arm:   \")[0-9a-f]{64}(\",)$|\1${arm}\2|" \
  -e "s|^(         intel: \")[0-9a-f]{64}(\")$|\1${intel}\2|" \
  "$cask"
rm -f "$cask.bak"

# A silent sed miss would leave a cask that installs the old version under
# the new checksums, so confirm every value actually landed.
grep -qF "version \"${version}\"" "$cask"
grep -qF "$arm" "$cask"
grep -qF "$intel" "$cask"

echo "gitwarren ${version}"
