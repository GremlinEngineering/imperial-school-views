#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
swiftc -swift-version 5 -parse-as-library Sources/Core/InstanceLease.swift validation/lease/Checks.swift -o "$WORK/lease-checks"
"$WORK/lease-checks"
"$WORK/lease-checks" --permissions "$WORK/permission-case"
