#!/bin/bash
# Load the built plug-in with ScreenSaver.framework, using the engine's test feed.
set -euo pipefail
KIT=$(cd "$(dirname "$0")/.." && pwd)
if [ "$(uname -s)" != Darwin ] || [ "$#" -ne 1 ]; then
  printf '%s\n' 'Usage on macOS: bash validation/check-saver.sh FILE.dmg' >&2
  exit 2
fi
DMG=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
WORK=$(mktemp -d)
MOUNT="$WORK/disk"
ATTACHED=0
cleanup() {
  if [ "$ATTACHED" = 1 ]; then
    hdiutil detach -quiet "$MOUNT" || return
  fi
  rm -rf "$WORK"
}
trap cleanup EXIT
xcrun clang -fobjc-arc -framework AppKit -framework ScreenSaver "$KIT/validation/SaverChecks.m" -o "$WORK/saver-checks"
mkdir "$MOUNT"
hdiutil attach -quiet -readonly -nobrowse -mountpoint "$MOUNT" "$DMG"
ATTACHED=1
APP="$MOUNT/Imperial School Views.app"
SAVER="$APP/Contents/PlugIns/Imperial School Views.saver"
codesign --verify --deep --strict "$APP"
xcrun lipo -verify_arch arm64 x86_64 "$APP/Contents/MacOS/ImperialSchoolViews"
xcrun lipo -verify_arch arm64 x86_64 "$SAVER/Contents/MacOS/ImperialSchoolSaver"
"$KIT/validation/check-engine.sh" "$WORK/fixtures"
"$WORK/saver-checks" "$SAVER" "$WORK/fixtures"
