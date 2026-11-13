#!/usr/bin/env python3
"""Insert the 0.8.9 UI hooks into a decoded official 0.8.8 APK."""
from pathlib import Path
import re
import sys

PACKAGE = "ru/oopssre/imperialschool/viewstv"
SCENE = f"L{PACKAGE}/TvScene;"
UI = f"L{PACKAGE}/BlogUi;"
MUSIC = f"L{PACKAGE}/SceneMusic;"


def exact(text, old, new):
    if text.count(old) != 1:
        raise ValueError(f"Expected one occurrence: {old[:120]}")
    return text.replace(old, new, 1)


def method(text, signature, change):
    pattern = rf"^\.method [^\n]*\b{re.escape(signature)}\n.*?^\.end method$"
    updated, count = re.subn(pattern, lambda match: change(match[0]), text, flags=re.M | re.S)
    if count != 1:
        raise ValueError(f"Expected one method: {signature}")
    return updated


def hook(registers, signature):
    return f"    invoke-static {{{registers}}}, {UI}->{signature}\n\n"


def scene(path):
    text = path.read_text()
    hooks = [
        ("text(Ljava/lang/String;I)Landroid/widget/TextView;",
         "    return-object v0", hook("p0, v0", f"text({SCENE}Landroid/widget/TextView;)V")),
        ("makeButton(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/Button;",
         "    return-object v0", hook("p0, v0", f"button({SCENE}Landroid/widget/Button;)V")),
        ("heading(Ljava/lang/String;)V",
         "    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V\n\n",
         ""),
        ("sectionHeading(Ljava/lang/String;)V",
         "    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V\n\n",
         ""),
    ]
    for signature, anchor, call in hooks:
        if not call:
            name = "section" if signature.startswith("section") else "heading"
            call = hook("p0, p1", f"{name}({SCENE}Landroid/widget/TextView;)V")
            text = method(text, signature, lambda block: exact(block, anchor, anchor + call))
        else:
            text = method(text, signature, lambda block: exact(block, anchor, call + anchor))
    begin = f"    invoke-virtual {{p0, p2}}, {SCENE}->heading(Ljava/lang/String;)V"
    text = method(text, "beginPage(Ljava/lang/String;Ljava/lang/String;)V", lambda block:
        exact(block, begin,
              hook("p0, p2", f"page({SCENE}Ljava/lang/String;)Ljava/lang/String;").rstrip()
              + "\n\n    move-result-object p2\n\n" + begin))
    text = method(text, "focusFirst(Ljava/lang/String;)V", lambda block:
        exact(block, "    .locals 3\n\n", "    .locals 3\n\n" + hook("p0", f"finish({SCENE})V")))
    text = method(text, "back()V", lambda block:
        exact(block, "    .locals 2\n\n", "    .locals 2\n\n"
              + hook("p0", f"back({SCENE})Z")
              + "    move-result v0\n\n    if-eqz v0, :blog_original_back\n\n"
                "    return-void\n\n    :blog_original_back\n"))
    text = method(text, "musicChanged()V", lambda block:
        block.replace("    return-void", hook("p0", f"refreshMusic({SCENE})V") + "    return-void"))
    for old, new in (
        ("Музыка в приложении", "Звук в приложении"),
        ("Музыка в заставке", "Звук в заставке"),
        ("Громкость · ", "Громкость приложения · "),
    ):
        encode = lambda s: s.encode("unicode_escape").decode().replace("\\xb7", "\\u00b7")
        old = encode(old)
        if old not in text:
            raise ValueError(f"Missing label: {old}")
        text = text.replace(old, encode(new))
    path.write_text(text)


def sound(path):
    text = path.read_text()
    def select(block):
        old = f"    invoke-virtual {{p0, v3}}, {MUSIC}->enabled(Z)V\n\n    return v3"
        new = (
            f"    invoke-virtual {{p0}}, {MUSIC}->enabled()Z\n\n"
            "    move-result v2\n\n    if-eqz v2, :blog_keep_muted\n\n"
            + old
            + f"\n\n    :blog_keep_muted\n    invoke-direct {{p0}}, {MUSIC}->ensure()V\n\n    return v3"
        )
        return exact(block,old,new)
    path.write_text(method(text, "playStation(Ljava/lang/String;)Z", select))


def main(decoded):
    root = decoded / "smali" / PACKAGE
    scene(root / "TvScene.smali")
    sound(root / "SceneMusic.smali")
    for name in ("BuildInfo", "TvScene", "RadioPlayback", "HttpTransport"):
        path = root / f"{name}.smali"
        text = path.read_text().replace("0.8.8", "0.8.9")
        if name == "BuildInfo":
            text = exact(text," CODE:I = 0x16"," CODE:I = 0x17")
        path.write_text(text)


if __name__ == "__main__":
    main(Path(sys.argv[1]))
