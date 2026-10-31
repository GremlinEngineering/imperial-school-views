#!/bin/bash
# Development-only portable coordinator checks; does not run AppKit or install anything.
set -euo pipefail
KIT=$(cd "$(dirname "$0")/.." && pwd)
cd "$KIT"
SWIFTC=${SWIFTC:-swiftc}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
python3 - "$KIT" "$WORK/Engine.swift" <<'PY'
from pathlib import Path
import sys
kit=Path(sys.argv[1]); source=(kit/'Sources/App/Engine.swift').read_text()
source='\n'.join(line for line in source.splitlines() if not line.startswith('import '))
start=source.index('        let validator:'); end=source.index('        store = CacheStore',start)
source=source[:start]+'        let validator: (URL,JSON) throws -> Void = { _,_ in }\n'+source[end:]
Path(sys.argv[2]).write_text('import Foundation\n'+source)
PY
BIN=$(swift build --show-bin-path --build-system native)
OBJECTS=()
LIBRARIES=(-lz)
if [ "$(uname -s)" = Linux ]; then LIBRARIES+=(-lcrypto); fi
for FILE in "$BIN"/ViewsNative.build/*.o "$BIN"/ZIPFoundation.build/*.o; do OBJECTS+=("$FILE"); done
"$SWIFTC" -swift-version 5 -parse-as-library -I "$BIN/Modules" -I "$KIT/Native/include" -I "$KIT/vendor/ZIPFoundation/Sources/CZLib" "$KIT"/Sources/Core/*.swift "$WORK/Engine.swift" "$KIT/validation/EnginePlatformStubs.swift" "$KIT/validation/EngineChecks.swift" "${OBJECTS[@]}" "${LIBRARIES[@]}" -o "$WORK/engine-checks"
"$WORK/engine-checks" "$KIT/Tests/Fixtures"
