"""Execute the changed updater instructions with Android lifecycle stand-ins."""
import json
from pathlib import Path
import re
import sys
from types import SimpleNamespace as Record

SMALI = Path(sys.argv[1])
PACKAGE = 'ru.oopssre.imperialschool.viewstv'
SETTINGS = 'android.settings.MANAGE_UNKNOWN_APP_SOURCES'
VIEW = 'android.intent.action.VIEW'


class Android:
    def __init__(self, *, permitted=True, available=True, dreaming=False):
        self.context = Record()
        self.activity = Record(kind='MainActivity', scene=None)
        self.dream = Record(kind='WallpaperDream')
        self.updater = Record(repo=Record(context=self.context))
        self.scene = Record(host=self.activity, context=self.context, updater=self.updater,
                            ready=None, updateStatus='')
        self.dream.scene = Record(**vars(self.scene), kind='TvScene')
        self.dream.scene.host = self.dream
        self.scene.kind = 'TvScene'
        self.activity.scene = self.scene
        self.permitted = permitted
        self.available = available
        self.active_dream = dreaming
        self.static = {'updateFromDream': False, 'SDK_INT': 28}
        self.events = []
        self.failure = None

    def platform(self, owner, method, args):
        obj = args[0] if args else None
        if (owner, method) in {('MainActivity', 'launch'), ('WallpaperDream', 'launch'), ('TvScene$Host', 'launch')}:
            if self.failure == 'launch':
                raise RuntimeError('no activity')
            intent = args[1]
            self.events.append((intent.action, intent.flags))
        elif method == 'leave':
            self.active_dream = False
            self.events.append(('end dream',))
        elif (owner, method) == ('TvScene', 'updatesMenu'):
            self.events.append(('menu',))
        elif (owner, method) == ('TvScene', 'refreshDetails'):
            self.events.append(('status', obj.updateStatus))
        elif method == 'ready':
            return self.available or None
        elif method == 'getPackageManager':
            return self
        elif method == 'canRequestPackageInstalls':
            return self.permitted
        elif method == 'getApkContentsSigners':
            return obj.signers
        elif method == 'getPackageName':
            return PACKAGE
        elif method == 'parse':
            return obj
        elif method == 'append':
            obj.value += args[1]
            return obj
        elif method == 'toString':
            return obj.value
        elif method == '<init>':
            if owner == 'StringBuilder':
                obj.value = args[1]
            elif len(args) == 3 and args[2] == 'MainActivity':
                obj.action = 'open MainActivity'
            else:
                obj.action = args[1]
                obj.data = args[2] if len(args) == 3 else None
        elif method == 'setDataAndType':
            obj.data, obj.mime = args[1:]
            return obj
        elif method == 'addFlags':
            obj.flags = args[1]
            return obj
        elif method == 'newRawUri':
            return args[1]
        elif method == 'setClipData':
            obj.clip = args[1]
        elif method == 'startActivityForResult':
            if self.failure == 'launch':
                raise RuntimeError('no settings')
            self.events.append((args[1].action, args[1].flags, args[2]))
        elif owner == 'Activity' and method in ('onActivityResult', 'onWindowFocusChanged'):
            pass
        else:
            raise AssertionError((owner, method, args))

    def run(self, cls, method, *args):
        source = (SMALI / (cls + '.smali')).read_text()
        match = re.search(r'(?ms)^\.method [^\n]*?(?<!\S)' + re.escape(method) + r'\([^\n]*\n(.*?)^\.end method', source)
        assert match, (cls, method)
        code = [s.strip() for s in match[1].splitlines() if s.strip() and not s.strip().startswith(('.', '#'))]
        labels = {s: i for i, s in enumerate(code) if s.startswith(':')}
        catches = [re.search(r'\{(:\w+) \.\. (:\w+)\} (:\w+)', s).groups()
                   for s in match[1].splitlines() if s.strip().startswith('.catch ')]
        regs = {f'p{i}': value for i, value in enumerate(args)}
        i = 0
        result = None
        while i < len(code):
            line = code[i]
            i += 1
            if line.startswith(':'):
                continue
            op, _, text = line.partition(' ')
            p = text.split(', ')
            field = lambda target: target.split('->')[1].split(':')[0]
            kind = lambda target: target.rsplit('/', 1)[-1].rstrip(';')
            if op.startswith('iget-'):
                regs[p[0]] = getattr(regs[p[1]], field(p[2]))
            elif op.startswith('iput-'):
                setattr(regs[p[1]], field(p[2]), regs[p[0]])
            elif op.startswith('sget'):
                regs[p[0]] = self.static[field(p[1])]
            elif op.startswith('sput-'):
                self.static[field(p[1])] = regs[p[0]]
            elif op == 'const-string':
                regs[p[0]] = json.loads(text.split(', ', 1)[1])
            elif op == 'const-class':
                regs[p[0]] = kind(p[1])
            elif op.startswith('const'):
                regs[p[0]] = int(p[1], 0)
            elif op == 'new-instance':
                regs[p[0]] = Record(kind=kind(p[1]), flags=0)
            elif op == 'instance-of':
                regs[p[0]] = regs[p[1]].kind == kind(p[2])
            elif op == 'check-cast':
                assert regs[p[0]].kind == kind(p[1])
            elif op.startswith('invoke-'):
                passed, target = text.split('}, ')
                owner, name = target.split('->')
                owner, name = kind(owner), name.split('(')[0]
                passed = [regs[x] for x in passed[1:].split(', ')] if passed != '{' else []
                nested = (owner, name) in {('MainActivity', 'openUpdateFromDream'),
                    ('MainActivity', 'openInstallPermission'), ('TvScene', 'install'),
                    ('TvScene', 'finishInstallPermission'), ('Updater', 'installer')}
                try:
                    result = self.run(owner, name, *passed) if nested else self.platform(owner, name, passed)
                except RuntimeError as error:
                    dest = next((end for start, stop, end in catches if labels[start] < i <= labels[stop]), None)
                    if dest is None:
                        raise
                    result, i = error, labels[dest]
            elif op.startswith('move-'):
                regs[p[0]] = result
            elif op == 'if-eqz' and not regs[p[0]] or op == 'if-nez' and regs[p[0]]:
                i = labels[p[1]]
            elif op == 'if-ne' and regs[p[0]] != regs[p[1]]:
                i = labels[p[2]]
            elif op == 'if-lt' and regs[p[0]] < regs[p[1]]:
                i = labels[p[2]]
            elif op == 'return-void':
                return
            elif op == 'return-object':
                return regs[p[0]]
            elif op == 'throw':
                raise regs[p[0]]
            else:
                assert op.startswith('if-'), line


a = Android()
intent = a.run('Updater', 'installer', a.updater)
assert intent.flags == 1 and intent.clip == intent.data and intent.data == f'content://{PACKAGE}.updates/update.apk'
a.run('TvScene', 'install', a.scene)
assert a.events == [(VIEW, 1)]
a = Android(available=False)
a.run('TvScene', 'install', a.scene)
assert a.events == [('menu',)] and a.scene.ready == 0
a = Android(dreaming=True)
a.run('TvScene', 'install', a.dream.scene)
assert a.events == [('open MainActivity', 0x34000000), ('end dream',)] and not a.active_dream
a.run('MainActivity', 'onWindowFocusChanged', a.activity, False)
assert len(a.events) == 2
a.run('MainActivity', 'onWindowFocusChanged', a.activity, True)
a.run('MainActivity', 'onWindowFocusChanged', a.activity, True)
assert a.events[-2:] == [('menu',), (VIEW, 1)] and a.events.count((VIEW, 1)) == 1
for allow in (False, True):
    a = Android(permitted=False, dreaming=True)
    a.run('TvScene', 'install', a.dream.scene)
    a.run('MainActivity', 'onWindowFocusChanged', a.activity, True)
    action, flags, request = a.events[-1]
    assert action == SETTINGS and flags == 0
    a.run('MainActivity', 'onActivityResult', a.activity, request + 1, 0, None)
    assert a.events[-1][0] == SETTINGS
    a.permitted = allow
    a.run('MainActivity', 'onActivityResult', a.activity, request, 0, None)
    assert a.events[-1][0] == (VIEW if allow else 'status')
for dreaming in (False, True):
    a = Android(dreaming=dreaming)
    a.failure = 'launch'
    a.run('TvScene', 'install', a.dream.scene if dreaming else a.scene)
    assert not a.static['updateFromDream'] and a.events[-1][0] == 'status' and a.active_dream == dreaming
print('PASS install handoff: ordinary app, dream dismissal, no duplicate launch, permission granted or declined, missing APK, failed activity launch.')

modern = Record(signingInfo=Record(signers=['current']), signatures=['legacy'])
legacy = Record(signingInfo=None, signatures=['legacy'])
missing = Record(signingInfo=None, signatures=None)
a = Android()
assert a.run('Updater', 'apkSigners', modern) == ['current']
assert a.run('Updater', 'apkSigners', legacy) == ['legacy']
assert a.run('Updater', 'apkSigners', missing) is None
a.static['SDK_INT'] = 26
assert a.run('Updater', 'apkSigners', modern) == ['legacy']
print('PASS signer selection for Android 8, Android 9 and missing signing data.')
