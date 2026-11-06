#!/usr/bin/env python3
from pathlib import Path
import os, subprocess, zipfile
root=Path(__file__).resolve().parents[2]
src=root/'tests/android';b=src/'build'
sdk=Path(os.environ.get('ANDROID_HOME',os.environ.get('ANDROID_SDK_ROOT','')))
bt=Path(os.environ.get('ANDROID_BUILD_TOOLS',str(sdk/'build-tools/36.0.0')))
jar=Path(os.environ.get('ANDROID_PLATFORM_JAR',str(sdk/'platforms/android-36/android.jar')))
key=os.environ.get('IMPERIAL_TV_KEYSTORE');password=os.environ.get('IMPERIAL_TV_PASSWORD_FILE')
if not key or not password:raise SystemExit('Use the same signing environment as build.py')
for name in ['classes','dex']:(b/name).mkdir(parents=True,exist_ok=True)
def run(*args):subprocess.run([str(x) for x in args],check=True)
run(bt/'aapt2','link','-I',jar,'--manifest',src/'AndroidManifest.xml','-o',b/'unsigned.apk')
run('java','--module','jdk.compiler/com.sun.tools.javac.Main','-encoding','UTF-8','-source','8','-target','8','-bootclasspath',str(jar)+os.pathsep+str(bt/'core-lambda-stubs.jar'),'-d',b/'classes',*src.glob('src/**/*.java'))
run('java','--module','jdk.jartool/sun.tools.jar.Main','--create','--file',b/'classes.jar','-C',b/'classes','.')
run('java','-cp',bt/'lib/d8.jar','com.android.tools.r8.D8','--lib',jar,'--min-api','26','--output',b/'dex',b/'classes.jar')
with zipfile.ZipFile(b/'unsigned.apk','a') as z:
 z.write(b/'dex/classes.dex','classes.dex')
 for f in (src/'assets').rglob('*'):
  if f.is_file():z.write(f,'assets/'+str(f.relative_to(src/'assets')))
run(bt/'zipalign','-f','4',b/'unsigned.apk',b/'aligned.apk')
run('java','-jar',bt/'lib/apksigner.jar','sign','--ks',key,'--ks-key-alias','tv','--ks-pass','file:'+password,'--out',b/'test.apk',b/'aligned.apk')
