#!/usr/bin/env python3
"""Sign an aligned 0.8.8 APK and create the site installer ZIP."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
from tempfile import TemporaryDirectory
from zipfile import ZIP_DEFLATED, ZipFile

APP_ID = "ru.oopssre.imperialschool.viewstv"
VERSION = "0.8.8"
BUILD = 22
CERTIFICATE = "67e2174516f404553dce739f482e87251f464c300a29d35789a9fb6e8bfbeeb5"


def run(*args, capture_output=False):
    return subprocess.run([str(arg) for arg in args], check=True, text=True, capture_output=capture_output)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("aligned_apk", type=Path)
    parser.add_argument("output_dir", type=Path)
    args = parser.parse_args()

    sdk = os.getenv("ANDROID_HOME") or os.getenv("ANDROID_SDK_ROOT") or "."
    tools = Path(os.getenv("ANDROID_BUILD_TOOLS") or Path(sdk) / "build-tools" / "36.0.0")
    key = os.getenv("IMPERIAL_TV_KEYSTORE")
    password_file = os.getenv("IMPERIAL_TV_PASSWORD_FILE")
    if not key or not password_file:
        raise SystemExit("Set IMPERIAL_TV_KEYSTORE and IMPERIAL_TV_PASSWORD_FILE.")
    signer = tools / "lib" / "apksigner.jar"
    if not signer.is_file():
        raise SystemExit("Set ANDROID_BUILD_TOOLS to Android Build Tools 36.0.0.")

    badging = run(tools / "aapt2", "dump", "badging", args.aligned_apk, capture_output=True).stdout
    expected = f"package: name='{APP_ID}' versionCode='{BUILD}' versionName='{VERSION}'"
    if not badging.startswith(expected):
        raise SystemExit("The input APK does not match this release.")

    args.output_dir.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(dir=args.output_dir, prefix=".tv-sign-") as directory:
        staging = Path(directory)
        apk = staging / f"ImperialSchoolViewsTV_{VERSION}.apk"
        run("java", "-jar", signer, "sign", "--ks", key, "--ks-key-alias", "tv",
            "--ks-pass", "file:" + password_file, "--out", apk, args.aligned_apk)
        verification = run("java", "-jar", signer, "verify", "--min-sdk-version", "26",
                           "--print-certs", apk, capture_output=True).stdout
        actual = re.findall(r"certificate SHA-256 digest: ([0-9a-f]{64})", verification)
        if actual != [CERTIFICATE]:
            raise SystemExit("The signing certificate does not match the official TV release.")
        run(tools / "zipalign", "-c", "-P", "16", "4", apk)

        data = apk.read_bytes()
        receipt = dict(schema=1, app_id=APP_ID, platform="android", version=VERSION, build=BUILD,
                       bytes=len(data), sha256=hashlib.sha256(data).hexdigest())
        archive = staging / f"ImperialSchoolViewsTV_{VERSION}_site.zip"
        with ZipFile(archive, "w", ZIP_DEFLATED) as package:
            package.writestr(apk.name, data)
            package.writestr("android-tv-release.json", json.dumps(receipt, indent=2) + "\n")
        output = args.output_dir / archive.name
        archive.replace(output)
    print(output)


if __name__ == "__main__":
    main()
