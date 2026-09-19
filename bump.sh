#!/usr/bin/env bash
# Re-stamp css/js URLs in index.html with a hash of each file's contents, so a
# changed file can never be served from a stale cache. Run after every edit.
#
# This is not housekeeping. A cached app.js cost real debugging time three
# separate times: the change was on disk, the page was running the old code, and
# the symptom looked like a logic bug every time.
cd "$(dirname "$0")"
python3 - <<'PY'
import re, hashlib
p='index.html'; s=open(p).read()
def stamp(m):
    attr, path = m.group(1), m.group(2)
    if path.startswith('http'): return m.group(0)
    try: h = hashlib.md5(open(path,'rb').read()).hexdigest()[:8]
    except OSError: return m.group(0)
    return '%s="%s?v=%s"' % (attr, path, h)
s = re.sub(r'(href)="((?:css|assets)/[^"?]+\.css)(?:\?v=[0-9a-f]+)?"', stamp, s)
s = re.sub(r'(src)="(js/[^"?]+\.js)(?:\?v=[0-9a-f]+)?"', stamp, s)
open(p,'w').write(s)
print('stamped')
PY
