#!/usr/bin/env python3
"""Replace only the app DEX and manifest version in the official APK."""
from pathlib import Path
from runpy import run_path
from struct import pack_into, unpack_from
from zipfile import ZipFile, ZipInfo
import sys

binary_xml = run_path(str(Path(__file__).resolve().parent.parent / "0.8.8" / "patch_apk.py"))


def updated_manifest(original):
    data = bytearray(original)
    read = None
    for kind, offset, header in binary_xml["chunks"](data):
        if kind == 1:
            read = binary_xml["string_pool"](data, offset, header)
        if kind != 0x102 or read is None:
            continue
        ext = offset + header
        _, name, start, size, count = unpack_from("<IIHHH", data, ext)
        if read(name)[3] != "manifest":
            continue
        changed = set()
        for i in range(count):
            at = ext + start + size * i
            namespace, name, raw, _, _, value_type, value = unpack_from("<IIIHBBI", data, at)
            if namespace == 0xffffffff or read(namespace)[3] != "http://schemas.android.com/apk/res/android":
                continue
            key = read(name)[3]
            if key == "versionCode":
                if value_type != 0x10 or value != 22:
                    raise ValueError("Expected 0.8.8 versionCode")
                pack_into("<I", data, at + 16, 23)
                changed.add(key)
            if key == "versionName":
                if value_type != 3 or raw not in (value, 0xffffffff):
                    raise ValueError("Unexpected versionName type")
                pos, length, codec, old = read(value)
                new = "0.8.9".encode(codec)
                if old != "0.8.8" or len(new) != length:
                    raise ValueError("Expected 0.8.8 versionName")
                data[pos:pos+length] = new
                changed.add(key)
        if changed != {"versionName", "versionCode"}:
            raise ValueError("Missing version attributes")
        return data
    raise ValueError("No manifest element")


def main(original, rebuilt, output):
    with ZipFile(original) as base, ZipFile(rebuilt) as patch, ZipFile(output, "w") as apk:
        if base.namelist().count("classes.dex") != 1 or "classes2.dex" in base.namelist():
            raise ValueError("Expected the original single DEX")
        for entry in base.infolist():
            name = entry.filename
            if name.startswith("META-INF/") and name.upper().endswith((".SF", ".RSA", ".DSA", ".EC", "/MANIFEST.MF")):
                continue
            data = base.read(entry)
            if name == "classes.dex":
                data = patch.read(name)
            elif name == "AndroidManifest.xml":
                data = updated_manifest(data)
            info = ZipInfo(name, entry.date_time)
            info.external_attr = entry.external_attr
            apk.writestr(info, data, compress_type=entry.compress_type)


if __name__ == "__main__":
    main(*sys.argv[1:])
