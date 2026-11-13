#!/usr/bin/env bash
set -euo pipefail
if [[ $# != 4 ]]; then
  echo 'Usage: rebuild_unsigned.sh OFFICIAL_0.8.8.apk APKTOOL.jar ANDROID_SDK_ROOT OUTPUT.apk' >&2
  exit 2
fi
base=$(cd "$(dirname "$0")" && pwd)
baseline=$1
apktool=$2
sdk=$3
output=$4
tools="$sdk/build-tools/35.0.0"
api="$sdk/platforms/android-35/android.jar"
package='ru/oopssre/imperialschool/viewstv'
expected=f78f6b4eba5db672c36b8c2d19121c6a8cb368063d761084c25f3bfecf048eb6
actual=$(python3 -c 'from hashlib import sha256; import sys; print(sha256(open(sys.argv[1], "rb").read()).hexdigest())' "$baseline")
if [[ "$actual" != "$expected" ]]; then
  echo 'Expected the official ImperialSchoolViewsTV 0.8.8 APK' >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/classes" "$work/stubs" "$work/dex"
javac --release 8 -encoding UTF-8 -cp "$api" -d "$work/stubs" "$base/compile-only/$package/ReleaseApi.java"
javac --release 8 -encoding UTF-8 -cp "$api:$work/stubs" -d "$work/classes" "$base/src/$package/BlogUi.java"
jar cf "$work/ui.jar" -C "$work/classes" .
"$tools/d8" --min-api 26 --lib "$api" --classpath "$work/stubs" --output "$work/dex" "$work/ui.jar"

cat > "$work/AndroidManifest.xml" <<'MANIFEST'
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="ru.oopssre.imperialschool.viewstv.blogbridge">
    <uses-sdk android:minSdkVersion="26" android:targetSdkVersion="35"/>
    <application/>
</manifest>
MANIFEST
"$tools/aapt2" link --manifest "$work/AndroidManifest.xml" -I "$api" -o "$work/ui.apk"
(cd "$work/dex" && zip -q "$work/ui.apk" classes.dex)
java -jar "$apktool" d -r -p "$work/framework" "$work/ui.apk" -o "$work/ui"
java -jar "$apktool" d -r -p "$work/framework" "$baseline" -o "$work/decoded"
python3 "$base/patch_release.py" "$work/decoded"
cp "$work/ui/smali/$package/"BlogUi*.smali "$work/decoded/smali/$package/"
java -jar "$apktool" b -f -p "$work/framework" "$work/decoded" -o "$work/reassembled.apk"
python3 "$base/repackage.py" "$baseline" "$work/reassembled.apk" "$work/unsigned.apk"
"$tools/zipalign" -f -P 16 4 "$work/unsigned.apk" "$output"
