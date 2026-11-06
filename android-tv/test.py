#!/usr/bin/env python3
"""Run the protocol/cache/remote-hold tests on a host JDK. No device or network."""
from pathlib import Path
import os
import subprocess
import tempfile

root = Path(__file__).resolve().parent
package = Path('ru/oopssre/imperialschool/viewstv')
main = root / 'app/src/main/java' / package
test = root / 'app/src/test/java' / package / 'CoreTests.java'
json_jar = root / 'vendor/test-json-20240303.jar'
with tempfile.TemporaryDirectory(prefix='imperial-tv-tests-') as directory:
    classes = Path(directory)
    subprocess.run([
        'java', '--module', 'jdk.compiler/com.sun.tools.javac.Main',
        '-encoding', 'UTF-8', '-classpath', os.pathsep.join([str(json_jar),str(root/'vendor/dec-0.1.2.jar')]), '-d', str(classes),
        *[str(main / (name + '.java')) for name in ['TvDisplay', 'ImageFormat', 'PlaybackPolicy', 'Protocol', 'Sources', 'HoldGate', 'Release', 'CacheStore','BuildInfo','VideoInfo','VideoPolicy','VideoLoader','HttpTransport','SceneCopy','ThemeText']],
        str(test),str(test.with_name('VideoTests.java')),str(test.with_name('RegressionTests.java')),str(test.with_name('DesignTests.java')),
    ], check=True)
    subprocess.run([
        'java', '-cp', os.pathsep.join([str(classes), str(json_jar),str(root/'vendor/dec-0.1.2.jar')]),
        'ru.oopssre.imperialschool.viewstv.CoreTests',
        str(root / 'app/src/test/resources'),
    ], check=True)
    subprocess.run(['java','-cp',os.pathsep.join([str(classes),str(json_jar),str(root/'vendor/dec-0.1.2.jar')]),
        'ru.oopssre.imperialschool.viewstv.VideoTests',str(root/'app/src/test/resources')],check=True)

    subprocess.run(['java','-cp',os.pathsep.join([str(classes),str(json_jar),str(root/'vendor/dec-0.1.2.jar')]),
        'ru.oopssre.imperialschool.viewstv.RegressionTests',str(root/'app/src/test/resources')],check=True)

    subprocess.run(['java','-cp',os.pathsep.join([str(classes),str(json_jar),str(root/'vendor/dec-0.1.2.jar')]),
        'ru.oopssre.imperialschool.viewstv.DesignTests',str(root/'app/src/test/resources')],check=True)
