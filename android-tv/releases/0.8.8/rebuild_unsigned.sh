#!/usr/bin/env bash
set -euo pipefail
if [[ $# != 4 ]]; then
  echo 'Usage: rebuild_unsigned.sh OFFICIAL_0.8.7.apk APKTOOL_2.12.1.jar ANDROID_BUILD_TOOLS OUTPUT.apk' >&2
  exit 2
fi
base=$(cd "$(dirname "$0")" && pwd)
baseline=$1
apktool=$2
tools=$3
output=$4
expected=92eb87f27cd5c501159a9aa178898abcc22f287419b971e6d508ffb28558957e
printf '%s  %s\n' "$expected" "$baseline" | sha256sum --check --status
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
java -jar "$apktool" d -r "$baseline" -o "$work/decoded"
patch --batch --forward -p1 -d "$work/decoded" < "$base/update_handoff.patch"
python3 "$base/qa/check_handoff.py" "$work/decoded/smali/ru/oopssre/imperialschool/viewstv"
java -jar "$apktool" b -f "$work/decoded" -o "$work/reassembled.apk"
python3 "$base/patch_apk.py" "$baseline" "$work/reassembled.apk" "$work/unsigned.apk"
"$tools/zipalign" -f -P 16 4 "$work/unsigned.apk" "$output"
