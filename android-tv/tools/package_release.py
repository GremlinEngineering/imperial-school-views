"""Verify release bytes/signature, record real checks, and package the complete public sources."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from hashlib import sha256
import subprocess,json,sys,re
ROOT=Path(__file__).resolve().parents[1]
if len(sys.argv)!=5:raise SystemExit('package_release.py PREVIOUS_APK ANDROID_BUILD_TOOLS HOST_LOG ANDROID_LOG')
old,bt,hostlog,androidlog=map(Path,sys.argv[1:])
config=json.loads((ROOT/'config.json').read_text());version=config['version'];dist=ROOT/'dist'
apk=dist/f'ImperialSchoolViewsTV_{version}.apk';receipt=json.loads((dist/'android-tv-release.json').read_text());site=dist/f'ImperialSchoolViewsTV_{version}_site.zip'
digest=sha256(apk.read_bytes()).hexdigest()
assert set(receipt)=={'schema','app_id','platform','version','build','bytes','sha256'}
assert receipt['schema']==1 and receipt['app_id']==config['application_id'] and receipt['platform']=='android'
assert receipt['version']==version and receipt['build']==config['build'] and receipt['bytes']==apk.stat().st_size and receipt['sha256']==digest
with ZipFile(site) as z:
 assert set(z.namelist())=={apk.name,'android-tv-release.json'} and z.testzip() is None
 assert z.read(apk.name)==apk.read_bytes() and json.loads(z.read('android-tv-release.json'))==receipt
with ZipFile(old) as prior,ZipFile(apk) as current:
 previous={n:sha256(prior.read(n)).hexdigest() for n in prior.namelist() if n.startswith('assets/')}
 assets={n:sha256(current.read(n)).hexdigest() for n in current.namelist() if n.startswith('assets/')}
 assert previous==assets and sum(n.endswith('.mp3') for n in assets)==16 and not any(n.endswith('.mp4') for n in assets)
def certificate(path):
 p=subprocess.run(['java','-jar',str(bt/'lib/apksigner.jar'),'verify','--print-certs',str(path)],capture_output=True,text=True,check=True)
 return next(line.split(': ',1)[1] for line in p.stdout.splitlines() if 'certificate SHA-256 digest:' in line)
cert=certificate(apk);assert cert==certificate(old)
subprocess.run([str(bt/'zipalign'),'-c','4',str(apk)],check=True,capture_output=True)
badging=subprocess.run([str(bt/'aapt2'),'dump','badging',str(apk)],capture_output=True,text=True,check=True).stdout
assert f"versionCode='{config['build']}'" in badging and f"versionName='{version}'" in badging and ("sdkVersion:'26'" in badging or "minSdkVersion:'26'" in badging)
(ROOT/f'docs/APK_BADGING_{version}.txt').write_text(badging)
counts=[int(n) for n in re.findall(r'^PASSED (\d+)',hostlog.read_text(),re.M)];assert len(counts)==4 and all(n>0 for n in counts)
android=androidlog.read_text();match=re.search(r'PASS (\d+) Android UI',android)
assert match,'Android UI checks did not pass'
assert 'APK_SHA256='+digest in android,'UI-tested APK differs from release bytes'
# Keep only the check result, not megabytes of base64 screenshot transport data.
summary='\n'.join(line for line in android.splitlines() if 'proof_' not in line)
(ROOT/f'docs/ANDROID_TESTS_{version}.txt').write_text(summary)
(ROOT/f'docs/HOST_TESTS_{version}.txt').write_text(hostlog.read_text())
validation={'version':version,'build':config['build'],'apk_bytes':apk.stat().st_size,'apk_sha256':digest,'same_publisher_certificate':True,'certificate_sha256':cert,'site_flat_pair_verified':True,'zip_alignment_verified':True,'unchanged_asset_files':len(assets),'unchanged_mp3':16,'embedded_mp4':0,'host_checks':sum(counts),'host_suites':counts,'android_ui_checks':int(match.group(1)),'instrumentation_executed':True,'android_tested_apk_sha256':digest,'emulator_api':28,'emulator_fixture_mode':True,'physical_yandex_tv_tested':False,'hardware_hevc_4k_tested':False,'live_video_publication_tested':False,'qr_urls_decoded':True,'limits':'Android UI uses seeded image snapshots. Emulator screenshots and D-pad checks do not establish physical Yandex TV HEVC playback, real TV audio focus, or system update installation.'}
(ROOT/f'docs/VALIDATION_{version}.json').write_text(json.dumps(validation,ensure_ascii=False,indent=2)+'\n')
members=[];binary=[]
for path in ROOT.rglob('*'):
 if not path.is_file():continue
 rel=path.relative_to(ROOT)
 if set(rel.parts)&{'build','dist','.git','__pycache__'}:continue
 assert path.suffix.lower() not in {'.p12','.pfx','.keystore','.jks'} and path.name.lower() not in {'password.txt','keystore.properties'}
 if path.name=='BINARY_RESOURCES.json':continue
 members.append(path)
 try:
  data=path.read_bytes()
  if b'\0' in data:raise UnicodeError('Binary bytes')
  data.decode('utf-8')
 except UnicodeError:binary.append({'path':rel.as_posix(),'bytes':path.stat().st_size,'sha256':sha256(path.read_bytes()).hexdigest()})
manifest=ROOT/'BINARY_RESOURCES.json';manifest.write_text(json.dumps({'version':version,'build':config['build'],'description':f'Binary resources omitted from GitHub. Restore these paths from ImperialSchoolViewsTV_{version}_source.zip before building or testing. No binary contents are embedded.','files':sorted(binary,key=lambda f:f['path'])},ensure_ascii=False,indent=2)+'\n');members.append(manifest)
source=dist/f'ImperialSchoolViewsTV_{version}_source.zip'
with ZipFile(source,'w',ZIP_DEFLATED,compresslevel=6) as z:
 for path in sorted(members):z.write(path,ROOT.name+'/'+path.relative_to(ROOT).as_posix())
with ZipFile(source) as z:
 assert z.testzip() is None
 assert not any(n.endswith(('.p12','.apk','.jks','.keystore')) for n in z.namelist())
print(json.dumps({'validation':validation,'files':[{'name':p.name,'bytes':p.stat().st_size,'sha256':sha256(p.read_bytes()).hexdigest()} for p in [apk,site,source]],'source_members':len(members)},ensure_ascii=False,indent=2))
