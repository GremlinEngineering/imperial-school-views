#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
case "$(swiftc --version)" in
  *"Swift version 5."*) swift test --build-system native -j 1 ;;
  *) swift test --build-system native -j 1 --disable-swift-testing ;;
esac
./validation/check-engine.sh
./validation/check-startup.sh
./validation/check-lease.sh
case "$(swiftc --version)" in
  *"Swift version 5."*) printf '%s\n' 'Проверка изоляции Swift 6 требует компилятор Swift 6 или новее.' ;;
  *) ./validation/check-location.sh ;;
esac
swiftc -frontend -parse Sources/App/*.swift
if [ "$(uname -s)" = Darwin ]; then
  CHECK_DIR=$(mktemp -d)
  trap 'rm -rf "$CHECK_DIR"' EXIT
  BIN=$(swift build --show-bin-path --build-system native)
  swiftc -swift-version 5 -warnings-as-errors -emit-sil -whole-module-optimization -parse-as-library -sdk "$(xcrun --sdk macosx --show-sdk-path)" -I "$BIN/Modules" -I Native/include Sources/Core/*.swift Sources/App/*.swift -o "$CHECK_DIR/NativeApp.sil"
fi
bash -n build-macos.sh
