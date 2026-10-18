#!/usr/bin/env bash
# Points Formula/pitupitu.rb at a release of klarluft/pitupitu.
#
#   scripts/bump-pitupitu.sh            # the latest published, non-prerelease release
#   scripts/bump-pitupitu.sh v0.3.3     # a specific tag
#
# Nothing is computed here: the box agent's release workflow fills its formula
# template with the checksums of the tarballs it built in the same run and
# attaches the result as `pitupitu.rb` (packaging/homebrew/ over there). This
# copies that file in, after checking it is whole and is for this tag.
#
# Prints the version it landed on and exits 0 whether or not anything changed;
# the caller decides what to do with a diff. Needs `gh`; the repository is
# public.
set -euo pipefail

repo="klarluft/pitupitu"
root="$(cd "$(dirname "${0}")/.." && pwd)"
formula="${root}/Formula/pitupitu.rb"
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

gh release download "${tag}" --repo "${repo}" --dir "${work}" --pattern "pitupitu.rb" || true
# Releases before v0.3.3 carry no formula. Asked for one by tag, that is an
# error; on the schedule it only means there is nothing newer to copy.
[[ -f ${work}/pitupitu.rb ]] || {
  echo "release ${tag} has no pitupitu.rb asset - this tap cannot be pointed at it" >&2
  [[ -z ${1:-} ]] && exit 0
  exit 1
}

if grep -q '__[A-Z0-9_]*__' "${work}/pitupitu.rb"
then
  echo "pitupitu.rb from ${tag} still has unfilled placeholders" >&2
  exit 1
fi
grep -qF "/download/v${version}/" "${work}/pitupitu.rb" || {
  echo "pitupitu.rb from ${tag} does not point at ${tag}" >&2
  exit 1
}

cp "${work}/pitupitu.rb" "${formula}"
echo "pitupitu ${version}"
