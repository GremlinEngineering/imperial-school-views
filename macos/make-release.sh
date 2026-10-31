#!/bin/bash
# Create the server's input release.json from an existing DMG.
set -euo pipefail
if [ "$#" -ne 1 ] && [ "$#" -ne 3 ]; then
  printf '%s\n' 'Использование: bash make-release.sh FILE.dmg [VERSION BUILD]' >&2
  exit 2
fi
DMG=$1
VERSION=${2:-2.0.7}
BUILD=${3:-207}
VERSION_PATTERN='^(0|[1-9][0-9]{0,8})[.](0|[1-9][0-9]{0,8})[.](0|[1-9][0-9]{0,8})$'
if [[ ! $VERSION =~ $VERSION_PATTERN ]] || [[ ! $BUILD =~ ^[1-9][0-9]{0,9}$ ]] || [ "$BUILD" -gt 2147483647 ]; then
  printf '%s\n' 'Неверные версия или номер сборки.' >&2
  exit 2
fi
if [ ! -f "$DMG" ]; then
  printf 'DMG не найден: %s\n' "$DMG" >&2
  exit 2
fi
case "$DMG" in
  *.dmg|*.DMG) ;;
  *) printf '%s\n' 'Укажите файл DMG.' >&2; exit 2 ;;
esac
DIRECTORY=$(cd "$(dirname "$DMG")" && pwd)
DMG="$DIRECTORY/$(basename "$DMG")"
# Read stdin so arbitrary DMG filenames cannot affect shasum's output format.
SHA=$(/usr/bin/shasum -a 256 < "$DMG")
SHA=${SHA%% *}
if [[ ! $SHA =~ ^[a-f0-9]{64}$ ]]; then
  printf '%s\n' 'Не удалось вычислить SHA-256 DMG.' >&2
  exit 1
fi
TEMP_RELEASE=$(/usr/bin/mktemp "$DIRECTORY/.release.json.XXXXXX")
trap 'rm -f "$TEMP_RELEASE"' EXIT
cat > "$TEMP_RELEASE" <<EOF
{
  "schema": 1,
  "app_id": "ru.oopssre.imperial-school.views",
  "platform": "macos",
  "version": "$VERSION",
  "build": $BUILD,
  "sha256": "$SHA"
}
EOF
/bin/chmod u=rw,go=r "$TEMP_RELEASE"
/bin/mv -f "$TEMP_RELEASE" "$DIRECTORY/release.json"
printf 'Готово: %s/release.json\n' "$DIRECTORY"
