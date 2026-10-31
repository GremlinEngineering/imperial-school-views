#!/bin/bash
# Exercise actual startup methods with modeled platform adapters, never AppKit.
set -euo pipefail
cd "$(dirname "$0")/.."
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
python3 - "$WORK/Startup.swift" <<'PY'
from pathlib import Path
import sys
s=Path('Sources/App/Main.swift').read_text()
a=s.index('    func startupFailure('); b=s.index('    func rebuildMenu()',a)
c=s.index('    @objc func openSettings()'); d=s.index('    @objc func openViewer()',c)
e=s.index('    func applicationShouldHandleReopen('); f=s.index('    func applicationWillTerminate(',e)
methods=s[a:b]+s[c:d].replace('@objc ','')+s[e:f]
Path(sys.argv[1]).write_text('import Foundation\n@MainActor final class StartupDelegate { var engine: Engine!; var settings: SettingsWindow?, wantsSettings = false\n'+methods+'}\n')
PY
swiftc -swift-version 5 -parse-as-library validation/startup/Platform.swift "$WORK/Startup.swift" validation/startup/Checks.swift -o "$WORK/startup-checks"
"$WORK/startup-checks"
