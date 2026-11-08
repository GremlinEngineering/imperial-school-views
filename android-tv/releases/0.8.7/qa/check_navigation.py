"""Exercise the exact navigation bytecode against lightweight Android UI stand-ins."""
from pathlib import Path
from types import SimpleNamespace
import json
import re
import sys

scene_file = Path(sys.argv[1]) / "smali/ru/oopssre/imperialschool/viewstv/TvScene.smali"
code = scene_file.read_text()

class Scene:
    def __init__(self):
        self.panel = SimpleNamespace(visible=8)
        self.placeholder = SimpleNamespace(visible=8)
        self.controller = SimpleNamespace(frame=None)
        self.video = SimpleNamespace(playing=False)
        self.video_mode = False
        self.host = self.context = self.music = self
        self.dream = False
        self.now = 100
        self.exitBackUntil = 0
        self.exits = self.toasts = 0
        self.page = "menu"
        self.focusMemory = {"music": "stations"}
        self.scrollMemory = {"music": 90}
        self.available = True

    def invoke(self, owner, method, args):
        obj = args[0] if args else None
        if owner == "TvScene":
            if method == "videoEnabled": return self.video_mode
            if method == "openSettings": self.panel.visible = 0; self.placeholder.visible = 8; self.page = "menu"; return
            if method == "musicMenu": self.page = "music"; return
            if method == "closeSettings": self.panel.visible = 8; return
            if method == "showPage": self.page = args[1]; return
            return self.run(method)
        if method == "getVisibility": return obj.visible
        if method == "setVisibility": obj.visible = args[1]; return
        if method == "put": obj[args[1]] = args[2]; return
        if method == "remove": obj.pop(args[1], None); return
        if method == "leave": self.exits += 1; return
        if method == "uptimeMillis": return self.now
        if method == "makeText": return self
        if method == "show": self.toasts += 1; return
        if method == "playStation": return self.available
        if method == "equals": return obj == args[1]
        if method == "parent": return "menu"
        raise AssertionError((owner, method, args))

    def run(self, method, arg=None):
        match = re.search(r"(?ms)^\.method [^\n]*?(?<!\S)" + re.escape(method)
                          + r"\([^\n]*\n(.*?)^\.end method", code)
        instructions = [s.strip() for s in match[1].splitlines() if s.strip() and not s.strip().startswith(".")]
        labels = {s: i for i, s in enumerate(instructions) if s.startswith(":")}
        r = {"p0": self, "p1": arg}
        i = 0
        result = None
        while i < len(instructions):
            s = instructions[i]
            i += 1
            if s.startswith(":"): continue
            op, _, text = s.partition(" ")
            p = text.split(", ")
            if op.startswith("iget-"):
                r[p[0]] = getattr(r[p[1]], p[2].split("->")[1].split(":")[0])
            elif op.startswith("iput-"):
                setattr(r[p[1]], p[2].split("->")[1].split(":")[0], r[p[0]])
            elif op == "const-string":
                r[p[0]] = json.loads(text.split(", ", 1)[1])
            elif op.startswith("const/") or op.startswith("const-wide"):
                r[p[0]] = int(p[1], 0)
            elif op == "instance-of":
                r[p[0]] = self.dream
            elif op == "cmp-long":
                r[p[0]] = (r[p[1]] > r[p[2]]) - (r[p[1]] < r[p[2]])
            elif op == "add-long/2addr":
                r[p[0]] += r[p[1]]
            elif op.startswith("invoke-"):
                args, target = text.split("}, ")
                owner, name = target.split("->")
                regs = args[1:].split(", ") if args[1:] else []
                result = self.invoke(owner.rsplit("/",1)[-1][:-1], name.split("(")[0], [r[n] for n in regs])
            elif op.startswith("move-result"):
                r[p[0]] = result
            elif op.startswith("if-"):
                decision = {"if-eqz": lambda v: not v, "if-nez": bool, "if-ltz": lambda v: v < 0}[op]
                if decision(r[p[0]]): i = labels[p[1]]
            elif op == "goto":
                i = labels[p[0]]
            elif op == "return-void":
                return
            else:
                raise AssertionError(s)

s = Scene(); s.run("openMenuUntilFrame"); assert s.panel.visible == s.placeholder.visible == 0
s = Scene(); s.controller.frame = object(); s.run("openMenuUntilFrame"); assert s.panel.visible == 8
s = Scene(); s.video_mode = True; s.run("openMenuUntilFrame"); assert s.panel.visible == 0
s = Scene(); s.video_mode = s.video.playing = True; s.run("openMenuUntilFrame"); assert s.panel.visible == 8
s = Scene(); s.dream = True; s.run("openMenuUntilFrame"); assert s.panel.visible == 8
s = Scene(); s.panel.visible = 0; s.page = "music"; s.run("openMenuUntilFrame"); assert s.page == "music"
station = "lambda$stationsMenu$27$ru-oopssre-imperialschool-viewstv-TvScene"
s = Scene(); s.panel.visible = 0; s.page = "stations"; s.run(station, SimpleNamespace(id="9128-live"))
assert s.panel.visible == 0 and s.page == "music" and s.focusMemory["music"] == "volume" and "music" not in s.scrollMemory
s = Scene(); s.panel.visible = 0; s.page = "stations"; s.available = False; s.run(station, SimpleNamespace(id="invalid")); assert s.page == "stations"
s = Scene(); s.run("back"); assert s.exits == 0 and s.toasts == 1 and s.exitBackUntil == 2100
s.now = 2100; s.run("back"); assert s.exits == 0 and s.toasts == 2
s.now = 3100; s.run("back"); assert s.exits == 1 and s.exitBackUntil == 0
s = Scene(); s.dream = True; s.run("back"); assert s.exits == 1 and s.toasts == 0
s = Scene(); s.page = "music"; s.panel.visible = 0; s.run("back"); assert s.page == "menu" and s.exits == 0
s.run("back"); assert s.panel.visible == 8 and s.exits == 0
print("PASS exact navigation instructions: startup, station focus, menu Back, timeout, double Back and screensaver.")
