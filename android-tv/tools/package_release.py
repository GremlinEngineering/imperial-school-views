"""Verify the existing standard APK/site receipt and package public sources."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from hashlib import sha256
import subprocess,json,sys,re,shutil
ROOT=Path(__file__).resolve().parents[1]
if len(sys.argv)!=4:raise SystemExit('package_release.py PREVIOUS_APK ANDROID_BUILD_TOOLS TEST_LOG')
old=Path(sys.argv[1]).resolve();bt=Path(sys.argv[2]).resolve();testlog=Path(sys.argv[3]).resolve()
config=json.loads((ROOT/'config.json').read_text());version=config['version'];dist=ROOT/'dist';apk=dist/f'ImperialSchoolViewsTV_{version}.apk';receipt=json.loads((dist/'android-tv-release.json').read_text());site=dist/f'ImperialSchoolViewsTV_{version}_site.zip'
digest=sha256(apk.read_bytes()).hexdigest();assert set(receipt)=={'schema','app_id','platform','version','build','bytes','sha256'}
assert receipt['schema']==1 and receipt['app_id']==config['application_id'] and receipt['platform']=='android'
assert receipt['version']==version and receipt['build']==config['build'] and receipt['sha256']==digest and receipt['bytes']==apk.stat().st_size
with ZipFile(site) as z:
 assert set(z.namelist())=={apk.name,'android-tv-release.json'} and z.testzip() is None
 assert z.read(apk.name)==apk.read_bytes() and json.loads(z.read('android-tv-release.json'))==receipt
with ZipFile(old) as prior,ZipFile(apk) as current:
 original={n:sha256(prior.read(n)).hexdigest() for n in prior.namelist() if n.startswith('assets/')}
 assets={n:sha256(current.read(n)).hexdigest() for n in current.namelist() if n.startswith('assets/')}
 assert original==assets
 assert sum(n.endswith('.mp3') for n in assets)==16 and not any(n.endswith('.mp4') for n in assets)
def cert(path):
 value=subprocess.run(['java','-jar',str(bt/'lib/apksigner.jar'),'verify','--print-certs',str(path)],capture_output=True,text=True,check=True).stdout
 return next(line.split(': ',1)[1] for line in value.splitlines() if 'certificate SHA-256 digest:' in line)
certificate=cert(apk);assert certificate==cert(old)
badging=subprocess.run([str(bt/'aapt2'),'dump','badging',str(apk)],capture_output=True,text=True,check=True).stdout
assert "versionCode='11'" in badging and "versionName='0.6.0'" in badging and "minSdkVersion:'26'" in badging and "targetSdkVersion:'36'" in badging
(ROOT/'docs/APK_BADGING_0.6.0.txt').write_text(badging)
counts=[int(n) for n in re.findall(r'^PASSED (\d+)',testlog.read_text(),re.M)];assert counts==[73,34,44]
validation={'version':version,'build':config['build'],'android_sdk_platform':36,'min_sdk':26,'target_sdk':36,'apk_bytes':apk.stat().st_size,'apk_sha256':digest,'site_flat_pair_verified':True,'same_publisher_certificate':True,'certificate_sha256':certificate,'unchanged_asset_files':len(assets),'unchanged_mp3':16,'embedded_mp4':0,'host_checks':sum(counts),'host_suites':counts,'live_snapshot_collections':{'dynamic':2,'weather':3,'plain':4},'instrumentation_apk_compiled':(ROOT/'tests/android/build/test.apk').is_file(),'instrumentation_executed':False,'physical_yandex_tv_tested':False,'ui_review':'source navigation/copy audit; docs/UI_AUDIT_0.6.0.md','limits':'No Android TV emulator or physical TV available in this release environment.'}
(ROOT/'docs/VALIDATION_0.6.0.json').write_text(json.dumps(validation,ensure_ascii=False,indent=2)+'\n')
(ROOT/'docs/HOST_TESTS_0.6.0.txt').write_text(testlog.read_text())
source=dist/f'ImperialSchoolViewsTV_{version}_source.zip';members=[]
for path in ROOT.rglob('*'):
 if not path.is_file():continue
 rel=path.relative_to(ROOT);parts=set(rel.parts)
 if parts&{'build','dist','.git','__pycache__'}:continue
 assert path.suffix.lower() not in {'.p12','.pfx','.keystore','.jks'} and path.name.lower() not in {'password.txt','keystore.properties'}
 members.append(path)
with ZipFile(source,'w',ZIP_DEFLATED,compresslevel=6) as z:
 for path in sorted(members):z.write(path,ROOT.name+'/'+path.relative_to(ROOT).as_posix())
with ZipFile(source) as z:
 assert z.testzip() is None
 assert any(n.endswith('/TvScene.java') for n in z.namelist()) and any(n.endswith('/ImageFormat.java') for n in z.namelist())
 assert not any(n.endswith(('.p12','.apk','.jks','.keystore')) for n in z.namelist())
print(json.dumps({'verified':validation,'files':[{'name':p.name,'bytes':p.stat().st_size,'sha256':sha256(p.read_bytes()).hexdigest()} for p in [apk,site,source]],'source_members':len(members)},ensure_ascii=False,indent=2))
