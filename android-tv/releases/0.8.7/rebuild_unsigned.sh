#!/usr/bin/env bash
set -euo pipefail
if [[ $# != 4 ]]; then
  echo 'Usage: rebuild_unsigned.sh ORIGINAL_0.8.6.apk APKTOOL_2.12.1.jar ANDROID_BUILD_TOOLS OUTPUT.apk' >&2
  exit 2
fi
base=$(cd "$(dirname "$0")" && pwd)
baseline=$1
apktool=$2
tools=$3
output=$4
python3 - "$baseline" <<'PY'
from hashlib import sha256
from pathlib import Path
import sys
assert sha256(Path(sys.argv[1]).read_bytes()).hexdigest() == 'a8b287a109f8080ab97a10acb085605c17e3b1c535024126b457009b575fe3df', 'Use the signed 0.8.6 APK'
PY
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
java -jar "$apktool" d -r "$baseline" -o "$work/decompiled"
python3 "$base/restore_source.py" "$work/decompiled"
python3 "$base/qa/check_navigation.py" "$work/decompiled"
java -jar "$apktool" b -f "$work/decompiled" -o "$work/reassembled.apk"
python3 "$base/patch_apk.py" "$baseline" "$work/reassembled.apk" "$work/unsigned.apk"
"$tools/zipalign" -f -P 16 4 "$work/unsigned.apk" "$output"
