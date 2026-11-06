#!/usr/bin/env python3
"""Build a universal TV APK with the official Android SDK; no Gradle service required."""
from pathlib import Path
import os,json,subprocess,shutil,hashlib,zipfile
ROOT=Path(__file__).resolve().parent
config=json.loads((ROOT/'config.json').read_text());sdk=Path(os.environ.get('ANDROID_HOME',os.environ.get('ANDROID_SDK_ROOT','')))
tools=Path(os.environ.get('ANDROID_BUILD_TOOLS',str(sdk/'build-tools/36.0.0')))
platform=Path(os.environ.get('ANDROID_PLATFORM_JAR',str(sdk/'platforms/android-36/android.jar')))
java=shutil.which('java');key=os.environ.get('IMPERIAL_TV_KEYSTORE');password=os.environ.get('IMPERIAL_TV_PASSWORD_FILE')
if not tools.is_dir() or not platform.is_file():raise SystemExit('Set ANDROID_HOME to SDK 36, or ANDROID_BUILD_TOOLS and ANDROID_PLATFORM_JAR.')
if not key or not password:raise SystemExit('Set IMPERIAL_TV_KEYSTORE and IMPERIAL_TV_PASSWORD_FILE to the retained publisher key. Signing keys are not part of the source project.')
work=ROOT/'build';classes=work/'classes';generated=work/'generated';dex=work/'dex';dist=ROOT/'dist'
for d in [classes,generated,dex]:
 if d.exists():shutil.rmtree(d)
 d.mkdir(parents=True,exist_ok=True)
dist.mkdir(parents=True,exist_ok=True)
pkg=ROOT/'app/src/main/java/ru/oopssre/imperialschool/viewstv'
(pkg/'BuildInfo.java').write_text('package ru.oopssre.imperialschool.viewstv;\npublic final class BuildInfo { public static final String VERSION='+json.dumps(config['version'])+'; public static final int CODE='+str(config['build'])+'; }\n')
def run(*args):subprocess.run([str(x) for x in args],check=True,cwd=ROOT)
aapt=tools/'aapt2';suffix='.exe' if os.name=='nt' else ''
run(aapt,'compile','--dir',ROOT/'app/src/main/res','-o',work/'resources.zip')
run(aapt,'link','-I',platform,'--manifest',ROOT/'app/src/main/AndroidManifest.xml','--min-sdk-version',config['min_sdk'],'--target-sdk-version',config['target_sdk'],'--version-code',config['build'],'--version-name',config['version'],'--java',generated,'-o',work/'base.apk',work/'resources.zip')
source=list((ROOT/'app/src/main/java').rglob('*.java'))+list(generated.rglob('*.java'))
classpath=os.pathsep.join([str(platform),str(ROOT/'vendor/dec-0.1.2.jar')])
run(java,'--module','jdk.compiler/com.sun.tools.javac.Main','-encoding','UTF-8','-source','8','-target','8','-bootclasspath',str(platform)+os.pathsep+str(tools/'core-lambda-stubs.jar'),'-classpath',classpath,'-d',classes,*source)
run(java,'--module','jdk.jartool/sun.tools.jar.Main','--create','--file',work/'classes.jar','-C',classes,'.')
run(java,'-cp',tools/'lib/d8.jar','com.android.tools.r8.D8','--lib',platform,'--min-api',config['min_sdk'],'--output',dex,work/'classes.jar',ROOT/'vendor/dec-0.1.2.jar')
shutil.copy2(work/'base.apk',work/'unsigned.apk')
with zipfile.ZipFile(work/'unsigned.apk','a') as z:
 for f in dex.glob('*.dex'):z.write(f,f.name,compress_type=zipfile.ZIP_STORED)
 for f in (ROOT/'app/src/main/assets').rglob('*'):
  if f.is_file():z.write(f,'assets/'+str(f.relative_to(ROOT/'app/src/main/assets')),compress_type=zipfile.ZIP_STORED if f.suffix.lower() in ('.mp3','.mp4') else zipfile.ZIP_DEFLATED)
run(tools/'zipalign','-f','4',work/'unsigned.apk',work/'aligned.apk')
apk=dist/f'ImperialSchoolViewsTV_{config["version"]}.apk'
run(java,'-jar',tools/'lib/apksigner.jar','sign','--ks',key,'--ks-key-alias','tv','--ks-pass','file:'+password,'--out',apk,work/'aligned.apk')
run(java,'-jar',tools/'lib/apksigner.jar','verify','--verbose','--print-certs',apk)
sha=hashlib.sha256(apk.read_bytes()).hexdigest()
# Input receipt for views.root/installers/. The Gremlin publisher owns public URLs and assets/.
release={'schema':1,'app_id':config['application_id'],'platform':'android','version':config['version'],'build':config['build'],'bytes':apk.stat().st_size,'sha256':sha}
receipt=dist/'android-tv-release.json'
receipt.write_text(json.dumps(release,ensure_ascii=False,indent=2)+'\n')
with zipfile.ZipFile(dist/f'ImperialSchoolViewsTV_{config["version"]}_site.zip','w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
 z.write(apk,apk.name)
 z.write(receipt,receipt.name)
(dist/'SHA256SUMS.txt').write_text(sha+'  '+apk.name+'\n')
print('Built',apk.name,apk.stat().st_size,'bytes',sha)
