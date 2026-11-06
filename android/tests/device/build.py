#!/usr/bin/env python3
"""Build disposable-device UI checks; supply an existing portrait JPEG with --image."""
from pathlib import Path
import argparse, os, subprocess, tempfile, zipfile, shutil
root=Path(__file__).resolve().parents[2];here=Path(__file__).resolve().parent
p=argparse.ArgumentParser();p.add_argument('--image',type=Path,required=True);args=p.parse_args()
sdk=Path(os.environ['ANDROID_HOME']);bt=sdk/'build-tools/36.0.0';platform=sdk/'platforms/android-36/android.jar'
props=Path(os.environ['IMPERIAL_SIGNING_PROPERTIES']);values={}
for line in props.read_text().splitlines():
 if '=' in line and not line.lstrip().startswith('#'):
  key,value=line.split('=',1);values[key.strip()]=value.strip()
key=Path(values['storeFile']);key=key if key.is_absolute() else props.parent/key
work=here/'build';shutil.rmtree(work,ignore_errors=True)
for name in ['classes','dex','assets']:(work/name).mkdir(parents=True,exist_ok=True)
shutil.copy2(args.image,work/'assets/fixture.jpg')
def run(*args):subprocess.run([str(x) for x in args],check=True)
run(bt/'aapt2','link','-I',platform,'--manifest',here/'AndroidManifest.xml','-o',work/'unsigned.apk')
run('java','--module','jdk.compiler/com.sun.tools.javac.Main','-encoding','UTF-8','-source','8','-target','8','-bootclasspath',str(platform)+os.pathsep+str(bt/'core-lambda-stubs.jar'),'-d',work/'classes',*here.glob('src/*.java'))
run('java','--module','jdk.jartool/sun.tools.jar.Main','--create','--file',work/'classes.jar','-C',work/'classes','.')
run('java','-cp',bt/'lib/d8.jar','com.android.tools.r8.D8','--lib',platform,'--min-api','26','--output',work/'dex',work/'classes.jar')
with zipfile.ZipFile(work/'unsigned.apk','a') as z:
 z.write(work/'dex/classes.dex','classes.dex');z.write(work/'assets/fixture.jpg','assets/fixture.jpg')
run(bt/'zipalign','-f','4',work/'unsigned.apk',work/'aligned.apk')
with tempfile.TemporaryDirectory() as private:
 os.chmod(private,0o700);ks=Path(private)/'ks';kp=Path(private)/'key'
 ks.write_text(values['storePassword']);kp.write_text(values.get('keyPassword',values['storePassword']))
 os.chmod(ks,0o600);os.chmod(kp,0o600)
 run('java','-jar',bt/'lib/apksigner.jar','sign','--ks',key,'--ks-key-alias',values['keyAlias'],'--ks-pass','file:'+str(ks),'--key-pass','file:'+str(kp),'--out',work/'test.apk',work/'aligned.apk')
print('Built',work/'test.apk')
