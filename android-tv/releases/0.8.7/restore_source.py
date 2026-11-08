#!/usr/bin/env python3
"""Overlay the recovered 0.8.7 application sources on a decoded 0.8.6 APK."""
from pathlib import Path
import re
import shutil
import sys

PACKAGE = Path("smali/ru/oopssre/imperialschool/viewstv")
LOCAL_CODE = "__PERSONAL_MODE_CODE_FROM_BASE_APK__"


def restore_source(decoded):
    sources = Path(__file__).resolve().parent / PACKAGE
    target = decoded / PACKAGE
    expected_files = {file.name for file in sources.glob("*.smali")}
    baseline_files = {file.name for file in target.glob("*.smali")}
    if not expected_files or expected_files != baseline_files:
        raise ValueError("Application classes do not match the 0.8.6 baseline")

    old_scene = (target / "TvScene.smali").read_text()
    handler = re.search(r"(?ms)^\.method [^\n]*lambda\$enterPersonalCode\$[^\n]*\n(.*?)^\.end method", old_scene)
    if handler is None:
        raise ValueError("Personal mode handler missing from the baseline")
    code = re.search(r'(?m)^    const-string p2, "([0-9]{4})"$', handler[1])
    if code is None:
        raise ValueError("Personal mode code missing from the baseline")
    scene = (sources / "TvScene.smali").read_text()
    if scene.count(LOCAL_CODE) != 1:
        raise ValueError("Expected a single private-code marker")

    shutil.copytree(sources, target, dirs_exist_ok=True)
    (target / "TvScene.smali").write_text(scene.replace(LOCAL_CODE, code[1]))


if __name__ == "__main__":
    restore_source(Path(sys.argv[1]))
