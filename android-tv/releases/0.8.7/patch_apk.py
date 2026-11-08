#!/usr/bin/env python3
"""Repackage exactly the app DEX and manifest version over the signed 0.8.6 baseline."""
from pathlib import Path
from struct import pack_into, unpack_from
from zipfile import ZipFile, ZipInfo
import sys


def chunks(data):
    kind, header, total = unpack_from("<HHI", data)
    if kind != 3 or total != len(data):
        raise ValueError("Expected an Android binary manifest")
    offset = header
    while offset < total:
        kind, header, size = unpack_from("<HHI", data, offset)
        if size < header or header < 8 or offset + size > total:
            raise ValueError("Invalid Android XML chunk")
        yield kind, offset, header
        offset += size


def string_pool(data, offset, header):
    count, _, flags, start, _ = unpack_from("<IIIII", data, offset + 8)
    utf8 = flags & 0x100

    def length(at, unit):
        first = int.from_bytes(data[at:at+unit], "little")
        at += unit
        mask = 1 << (unit*8-1)
        if first & mask:
            first = ((first & (mask-1)) << (unit*8)) | int.from_bytes(data[at:at+unit], "little")
            at += unit
        return first, at

    def read(index):
        if index >= count:
            raise ValueError("Invalid Android string index")
        rel, = unpack_from("<I", data, offset + header + index * 4)
        at = offset + start + rel
        n, at = length(at, 1 if utf8 else 2)
        if utf8:
            n, at = length(at, 1)
        else:
            n *= 2
        codec = "utf-8" if utf8 else "utf-16-le"
        return at, n, codec, data[at:at+n].decode(codec)

    return read


def updated_manifest(original):
    data = bytearray(original)
    read = None
    for kind, offset, header in chunks(data):
        if kind == 1:
            read = string_pool(data, offset, header)
        if kind != 0x102 or read is None:
            continue
        ext = offset + header
        _, name, attr_start, attr_size, count = unpack_from("<IIHHH", data, ext)
        if read(name)[3] != "manifest":
            continue
        changed = set()
        for index in range(count):
            at = ext + attr_start + attr_size * index
            ns, name, raw, size, _, value_type, value = unpack_from("<IIIHBBI", data, at)
            if ns == 0xffffffff or read(ns)[3] != "http://schemas.android.com/apk/res/android":
                continue
            name = read(name)[3]
            if name == "versionCode":
                assert value_type == 0x10 and value == 20
                pack_into("<I", data, at + 16, 21)
                changed.add(name)
            if name == "versionName":
                assert value_type == 3 and raw in (value, 0xffffffff)
                start, length, codec, old = read(value)
                assert old == "0.8.6"
                new = "0.8.7".encode(codec)
                assert len(new) == length
                data[start:start+length] = new
                changed.add(name)
        if changed != {"versionCode", "versionName"}:
            raise ValueError("Manifest version was not updated")
        return data
    raise ValueError("Manifest root not found")


def main():
    baseline, rebuilt, output = map(Path, sys.argv[1:])
    with ZipFile(baseline) as original, ZipFile(rebuilt) as patch, ZipFile(output, "w") as apk:
        assert original.namelist().count("classes.dex") == 1
        for entry in original.infolist():
            name = entry.filename
            if name.startswith("META-INF/") and name.upper().endswith((".SF", ".RSA", ".DSA", ".EC", "/MANIFEST.MF")):
                continue
            data = original.read(entry)
            if name == "classes.dex":
                data = patch.read(name)
            if name == "AndroidManifest.xml":
                data = updated_manifest(data)
            info = ZipInfo(name, entry.date_time)
            info.external_attr = entry.external_attr
            apk.writestr(info, data, compress_type=entry.compress_type)


if __name__ == "__main__":
    main()
