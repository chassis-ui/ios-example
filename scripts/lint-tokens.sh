#!/bin/sh
#
# Checks the rule of this example: every value comes from a token, and every asset from the
# release. It reads ChassisExample/ and, for the names of the icons and images, Generated/.

set -u

root="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$root/ChassisExample"
assets="$root/Generated/assets"
failed=0

report() {
  echo "error: $1" >&2
  failed=1
}

# The lines of the source that match a pattern, without their comments and strings, so that copy
# is free to hold a number or a word. AppModel.swift holds the content of the example.
check() {
  # $1 what is wrong, $2 the pattern
  matches="$(find "$source_dir" -name '*.swift' ! -name 'AppModel.swift' -print0 |
    PATTERN="$2" xargs -0 awk '{
      line = $0
      sub(/^[[:space:]]*\/\/.*/, "", line)
      gsub(/"[^"]*"/, "\"\"", line)
      if (line ~ ENVIRON["PATTERN"]) print FILENAME ":" FNR ": " line
    }')"
  if [ -n "$matches" ]; then
    report "$1:"
    echo "$matches" | sed "s|$root/||" >&2
  fi
}

check "a color that is no token" 'Color\((red|white|hue)|Color\.(white|black|gray|red|blue|green|orange|yellow|pink|purple)|\.foregroundStyle\(\.(white|black|gray|red|blue|primary|secondary)'
check "a system font" '\.font\(\.(body|title|title2|title3|headline|subheadline|callout|footnote|caption|caption2|largeTitle|system)|systemFont'
check "an SF Symbol, which is no asset of the brand" 'systemName:|systemImage:'
check "a branch on a brand" '#if |CHASSIS_BRAND'
check "a number that is no token" '(^|[^A-Za-z0-9_.])(0\.[0-9]+|[3-9]|[1-9][0-9]+)([^0-9A-Za-z_.]|$)'

# The source never names a brand or a family: both come from the tokens
for word in chassis sinefil Montserrat Inter Lora Geist Cousine 'Fira Code'; do
  matches="$(grep -rnw --include='*.swift' "$word" "$source_dir")"
  if [ -n "$matches" ]; then
    report "the source names \"$word\":"
    echo "$matches" | sed "s|$root/||" >&2
  fi
done

# Each name of ChassisAssets.swift is in a catalog of the release
if [ ! -d "$assets" ]; then
  report "Generated/ is missing: run scripts/sync-brand.sh first"
else
  names="$(sed -n 's/^[[:space:]]*case [A-Za-z]* = "\(.*\)"$/\1/p' "$source_dir/Chassis/ChassisAssets.swift")"
  for name in $names; do
    if [ ! -d "$assets/Icons.xcassets/$name.imageset" ] && [ ! -d "$assets/Assets.xcassets/$name.imageset" ]; then
      report "\"$name\" is in no catalog of the release"
    fi
  done
fi

if [ "$failed" -eq 0 ]; then
  echo "Every value is a token, and every asset is in the release."
fi
exit "$failed"
