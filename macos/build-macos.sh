#!/bin/bash
set -Eeuo pipefail
KIT=$(cd "$(dirname "$0")" && pwd)
OUTPUT="$KIT/dist"
SIGNED=0
APP_ONLY=0
DEVELOPMENT=0
STAGE='подготовка'
trap 'printf "Сборка остановлена: %s (код %s).\n" "$STAGE" "$?" >&2' ERR
while [ "$#" -gt 0 ]; do
  case "$1" in
    --output) if [ "$#" -lt 2 ]; then printf "Укажите каталог после --output\n" >&2; exit 2; fi; OUTPUT=$2; shift 2 ;;
    --signed) SIGNED=1; shift ;;
    --app-only) APP_ONLY=1; shift ;;
    --development) DEVELOPMENT=1; shift ;;
    --check) /bin/bash "$KIT/test-core.sh"; exit ;;
    -h|--help) printf '%s\n' './build-macos.sh [--output DIRECTORY] [--signed] [--app-only] [--development]' 'По умолчанию: универсальные Swift/AppKit .app и нативный .saver в DMG.' 'Сборка не запускает приложение и не меняет обои.'; exit ;;
    *) printf 'Неизвестный параметр: %s\n' "$1" >&2; exit 2 ;;
  esac
done
if [ "$(uname -s)" != Darwin ]; then printf 'Для сборки .app и DMG нужен Mac с Command Line Tools или Xcode.\n' >&2; exit 2; fi
SDK=$(/usr/bin/xcrun --sdk macosx --show-sdk-path)
/usr/bin/xcrun --find swiftc >/dev/null
mkdir -p "$OUTPUT"
OUTPUT=$(cd "$OUTPUT" && pwd)
BUILD=$(/usr/bin/mktemp -d "$OUTPUT/.views-native.XXXXXX")
trap '/bin/rm -rf "$BUILD"' EXIT
FOLDER="$BUILD/disk"
APP="$FOLDER/Imperial School Views.app"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$KIT/Resources/Info.plist" "$APP/Contents/Info.plist"
cp -R "$KIT/branding" "$KIT/preview-samples" "$KIT/licences" "$APP/Contents/Resources/"
for ARCH in arm64 x86_64; do
  STAGE="компиляция $ARCH"
  DIR="$BUILD/$ARCH"
  mkdir -p "$DIR"
  OBJECTS=()
  for SOURCE in "$KIT"/Native/*.c; do
    OBJECT="$DIR/$(basename "${SOURCE%.c}").o"
    /usr/bin/xcrun clang -target "$ARCH-apple-macos12.0" -isysroot "$SDK" -O2 -DBROTLI_BUILD_PORTABLE -DBROTLI_STATIC -I "$KIT/vendor/brotli/c/include" -c "$SOURCE" -o "$OBJECT"
    OBJECTS+=("$OBJECT")
  done
  /usr/bin/xcrun swiftc -swift-version 5 -sdk "$SDK" -target "$ARCH-apple-macos12.0" -O -parse-as-library -module-name ZIPFoundation -emit-module -emit-module-path "$DIR/ZIPFoundation.swiftmodule" -emit-library -static "$KIT"/vendor/ZIPFoundation/Sources/ZIPFoundation/*.swift -o "$DIR/libZIPFoundation.a"
  /usr/bin/xcrun swiftc -swift-version 5 -sdk "$SDK" -target "$ARCH-apple-macos12.0" -O -parse-as-library -I "$KIT/Native/include" -I "$DIR" -L "$DIR" -lZIPFoundation "$KIT"/Sources/Core/*.swift "$KIT"/Sources/App/*.swift "${OBJECTS[@]}" -framework AppKit -framework CoreLocation -framework ColorSync -framework ImageIO -framework UserNotifications -framework UniformTypeIdentifiers -lcompression -lz -o "$DIR/ImperialSchoolViews"
  if [ "$APP_ONLY" != 1 ]; then
    /usr/bin/xcrun clang -target "$ARCH-apple-macos12.0" -isysroot "$SDK" -fobjc-arc -fblocks -bundle -O2 -framework ScreenSaver -framework AppKit -framework ColorSync "$KIT/screensaver/ImperialSchoolSaverView.m" -o "$DIR/ImperialSchoolSaver"
  fi
done
/usr/bin/xcrun lipo -create "$BUILD/arm64/ImperialSchoolViews" "$BUILD/x86_64/ImperialSchoolViews" -output "$APP/Contents/MacOS/ImperialSchoolViews"
STAGE='значок'
ICONSET="$BUILD/Views.iconset"
mkdir -p "$ICONSET"
for SIZE in 16 32 128 256 512; do
  /usr/bin/sips -z "$SIZE" "$SIZE" "$KIT/branding/app-icon.png" --out "$ICONSET/icon_${SIZE}x${SIZE}.png" >/dev/null
  /usr/bin/sips -z "$((SIZE * 2))" "$((SIZE * 2))" "$KIT/branding/app-icon.png" --out "$ICONSET/icon_${SIZE}x${SIZE}@2x.png" >/dev/null
done
/usr/bin/iconutil -c icns -o "$APP/Contents/Resources/Views.icns" "$ICONSET"
IDENTITY='-'
if [ "$SIGNED" = 1 ]; then
  : "${DEVELOPER_ID_APPLICATION:?Задайте сертификат Developer ID Application}"
  : "${NOTARY_KEYCHAIN_PROFILE:?Задайте профиль notarytool}"
  IDENTITY="$DEVELOPER_ID_APPLICATION"
fi
sign_bundle() {
  if [ "$SIGNED" = 1 ]; then
    /usr/bin/codesign --force --sign "$IDENTITY" --options runtime --timestamp "$1"
  else
    /usr/bin/codesign --force --sign - "$1"
  fi
}
if [ "$APP_ONLY" != 1 ]; then
  STAGE='хранитель'
  SAVER="$FOLDER/Imperial School Views.saver"
  mkdir -p "$SAVER/Contents/MacOS" "$SAVER/Contents/Resources" "$APP/Contents/PlugIns"
  cp "$KIT/screensaver/Info.plist" "$SAVER/Contents/Info.plist"
  /usr/bin/xcrun lipo -create "$BUILD/arm64/ImperialSchoolSaver" "$BUILD/x86_64/ImperialSchoolSaver" -output "$SAVER/Contents/MacOS/ImperialSchoolSaver"
  cp "$KIT/preview-samples/no-data.png" "$SAVER/Contents/Resources/no-data.png"
  cp "$APP/Contents/Resources/Views.icns" "$SAVER/Contents/Resources/Views.icns"
  sign_bundle "$SAVER"
  cp -R "$SAVER" "$APP/Contents/PlugIns/"
fi
STAGE='подпись приложения'
/usr/bin/plutil -lint "$APP/Contents/Info.plist"
sign_bundle "$APP"
/usr/bin/codesign --verify --deep --strict "$APP"
ln -s /Applications "$FOLDER/Applications"
cp "$APP/Contents/Resources/Views.icns" "$FOLDER/.VolumeIcon.icns"
cp "$KIT/branding/FinderLayout.dsstore" "$FOLDER/.DS_Store"
cp "$KIT/INSTALL.txt" "$FOLDER/Начните здесь.txt"
NAME='ImperialSchoolViews-Mac-2.0.7.dmg'
if [ "$DEVELOPMENT" = 1 ]; then NAME='ImperialSchoolViews-Mac-2.0.7-development.dmg'; fi
STAGE='образ диска'
/usr/bin/hdiutil create -quiet -volname 'Виды и обои · Школа Империи' -srcfolder "$FOLDER" -format UDZO -ov "$OUTPUT/$NAME"
if [ "$SIGNED" = 1 ]; then
  /usr/bin/codesign --force --sign "$IDENTITY" --timestamp "$OUTPUT/$NAME"
  /usr/bin/xcrun notarytool submit "$OUTPUT/$NAME" --keychain-profile "$NOTARY_KEYCHAIN_PROFILE" --wait
  /usr/bin/xcrun stapler staple "$OUTPUT/$NAME"
fi
STAGE='файл релиза'
/bin/bash "$KIT/make-release.sh" "$OUTPUT/$NAME" "2.0.7" "207"
printf 'Готово: %s\nФайл для публикации: %s/release.json\n' "$OUTPUT/$NAME" "$OUTPUT"
