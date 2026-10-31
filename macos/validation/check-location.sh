#!/bin/bash
# Portable concurrency regression, not an Apple SDK build.
set -euo pipefail
KIT=$(cd "$(dirname "$0")/.." && pwd)
cd "$KIT"
SWIFTC=${SWIFTC:-swiftc}
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
BIN=$(swift build --show-bin-path --build-system native)
OBJECTS=()
for FILE in "$BIN"/ViewsNative.build/*.o; do OBJECTS+=("$FILE"); done
LIBRARIES=(-lz)
if [ "$(uname -s)" = Linux ]; then LIBRARIES+=(-lcrypto); fi
"$SWIFTC" -swift-version 6 -warnings-as-errors -parse-as-library -module-name CoreLocation -emit-module -emit-module-path "$WORK/CoreLocation.swiftmodule" -emit-library -static "$KIT/validation/location/CoreLocation.swift" -o "$WORK/libCoreLocation.a"
"$SWIFTC" -swift-version 6 -warnings-as-errors -parse-as-library -I "$WORK" -L "$WORK" -lCoreLocation -I "$KIT/Native/include" "$KIT/Sources/Core/Model.swift" "$KIT/Sources/App/Location.swift" "$KIT/validation/location/Network.swift" "$KIT/validation/location/Checks.swift" "${OBJECTS[@]}" "${LIBRARIES[@]}" -o "$WORK/location-checks"
"$WORK/location-checks"
