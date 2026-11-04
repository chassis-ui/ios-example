#!/bin/sh
#
# Fills Generated/ with the tokens and the assets of one brand, and the icons, at the versions
# that Chassis.xcconfig pins. Xcode runs it as the first build phase. It needs no Node.js.
#
#   scripts/sync-brand.sh            The brand of Chassis.xcconfig
#   scripts/sync-brand.sh sinefil    Another brand
#
# Every download is checked against the digest GitHub records for it, and kept in .cache/.
# Nothing is written to Generated/ until every download has passed and the brand is known.

set -eu

fail() {
  # Xcode shows a line that starts with "error:" as a build error
  echo "error: $1" >&2
  exit 1
}

root="${SRCROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
config="$root/Chassis.xcconfig"

# A setting of Chassis.xcconfig. From a build it is in the environment, with a command line override
# among them. Outside a build this reads the file, and fills in a $(SETTING) in the value.
setting() {
  value="$(printenv "$1" || sed -n "s/^$1[[:space:]]*=[[:space:]]*//p" "$config")"
  while :; do
    case "$value" in
      *'$('*)
        name="${value#*\$(}"
        name="${name%%)*}"
        value="${value%%\$(*}$(setting "$name")${value#*)}"
        ;;
      *) break ;;
    esac
  done
  echo "$value"
}

CHASSIS_BRAND="${1:-$(setting CHASSIS_BRAND)}"
export CHASSIS_BRAND
brand="$CHASSIS_BRAND"
app="$(setting CHASSIS_APP)"
tokens_repository="$(setting CHASSIS_TOKENS_REPOSITORY)"
tokens_version="$(setting CHASSIS_TOKENS_VERSION)"
tokens_archive="$(setting CHASSIS_TOKENS_ARCHIVE)"
assets_repository="$(setting CHASSIS_ASSETS_REPOSITORY)"
assets_version="$(setting CHASSIS_ASSETS_VERSION)"
assets_archive="$(setting CHASSIS_ASSETS_ARCHIVE)"
icons_repository="$(setting CHASSIS_ICONS_REPOSITORY)"
icons_version="$(setting CHASSIS_ICONS_VERSION)"
icons_archive="$(setting CHASSIS_ICONS_ARCHIVE)"

generated="$root/Generated"
cache="$root/.cache"
stamp="$brand $tokens_repository@$tokens_version/$tokens_archive $assets_repository@$assets_version/$assets_archive $icons_repository@$icons_version/$icons_archive"

# Nothing changed: leave the files alone, so that Xcode has nothing to compile again
if [ "$(cat "$generated/.stamp" 2>/dev/null)" = "$stamp" ]; then
  exit 0
fi

mkdir -p "$cache"
# On the volume of Generated/, so that replacing it is one rename
work="$(mktemp -d "$cache/work.XXXXXX")"
trap 'rm -rf "$work" || true' EXIT

# The value at a path of a JSON file
json() {
  plutil -extract "$2" raw -o - "$1"
}

# Prints the path in .cache/ of an archive of a release, after downloading and checking it once.
# $1 the repository, $2 the version, $3 the name of the archive
fetch() {
  cached="$cache/$(echo "$1" | tr '/' '-')-$3"
  if [ ! -f "$cached" ]; then
    echo "Downloading $3 from $1" >&2
    release="$work/release.json"
    # Without a token GitHub allows 60 calls an hour per address, which a shared runner can use up
    if [ -n "${GH_TOKEN:-}" ]; then
      curl -fsSL -H "Authorization: Bearer $GH_TOKEN" \
        "https://api.github.com/repos/$1/releases/tags/v$2" -o "$release" ||
        fail "cannot read release v$2 of $1: it does not exist, or GH_TOKEN has no access to it"
    else
      curl -fsSL "https://api.github.com/repos/$1/releases/tags/v$2" -o "$release" ||
        fail "cannot read release v$2 of $1: it does not exist, or GitHub's rate limit was reached. Setting GH_TOKEN raises the limit"
    fi
    count="$(json "$release" assets)"
    index=0
    digest=""
    url=""
    names=""
    while [ "$index" -lt "$count" ]; do
      name="$(json "$release" "assets.$index.name")"
      names="$names $name"
      if [ "$name" = "$3" ]; then
        digest="$(json "$release" "assets.$index.digest")"
        url="$(json "$release" "assets.$index.browser_download_url")"
      fi
      index=$((index + 1))
    done
    [ -n "$url" ] || fail "$1 v$2 has no $3. It has:$names"
    curl -fsSL "$url" -o "$work/download.zip"
    actual="sha256:$(shasum -a 256 "$work/download.zip" | cut -d ' ' -f 1)"
    [ "$actual" = "$digest" ] || fail "$3 does not match the digest of its release"
    mv "$work/download.zip" "$cached"
  fi
  echo "$cached"
}

mkdir "$work/tokens" "$work/assets" "$work/icons"
# Each on its own line: a failed download stops the script only as an assignment
tokens_zip="$(fetch "$tokens_repository" "$tokens_version" "$tokens_archive")"
assets_zip="$(fetch "$assets_repository" "$assets_version" "$assets_archive")"
icons_zip="$(fetch "$icons_repository" "$icons_version" "$icons_archive")"
unzip -q "$tokens_zip" -d "$work/tokens"
unzip -q "$assets_zip" -d "$work/assets"
unzip -q "$icons_zip" -d "$work/icons"

# --- Replace Generated/. The whole archive is kept, as a brand may hold more than this app reads.

# The files of two brands can have one modification time, which would hide a change from Xcode
find "$work/tokens" "$work/assets" "$work/icons" -type f -exec touch {} +
mkdir "$work/next"
mv "$work/tokens" "$work/next/tokens"
mv "$work/assets" "$work/next/assets"
mv "$work/icons" "$work/next/icons"
echo "$stamp" >"$work/next/.stamp"
if [ -e "$generated" ]; then
  mv "$generated" "$work/previous"
fi
mv "$work/next" "$generated"
echo "Generated/ now holds $stamp"
