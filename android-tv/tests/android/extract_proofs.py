#!/usr/bin/env python3
"""Decode proof_* instrumentation status lines from a captured am instrument log."""
from pathlib import Path
import sys,re,base64
source=Path(sys.argv[1]);destination=Path(sys.argv[2]);destination.mkdir(parents=True,exist_ok=True)
for line in source.read_text().splitlines():
 match=re.match(r'INSTRUMENTATION_STATUS: proof_(\w+)=(.+)$',line)
 if match:
  name,data=match.groups()
  if re.fullmatch(r'[a-zA-Z0-9_]+',name):(destination/(name+'.png')).write_bytes(base64.b64decode(data))
