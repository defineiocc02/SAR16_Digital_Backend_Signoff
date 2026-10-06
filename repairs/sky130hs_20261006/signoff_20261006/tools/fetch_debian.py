#!/usr/bin/env python3
import lzma,re,pathlib,subprocess,hashlib,json,concurrent.futures,sys
root=pathlib.Path(__file__).resolve().parent
packages={}
for b in lzma.open(root/'downloads/Packages-trixie-amd64.xz').read().decode().split('\n\n'):
 d={}
 for line in b.splitlines():
  if line and not line.startswith(' ') and ': ' in line:
   k,v=line.split(': ',1);d[k]=v
 if 'Package' in d:packages[d['Package']]=d
providers={}
for name,d in packages.items():
 for a in d.get('Provides','').split(','):
  namev=a.strip().split(' ')[0].split(':')[0]
  if namev:providers.setdefault(namev,name)
# Host runtime base is Debian 13. Avoid shadowing libc / dynamic loader.
skip={'libc6','libgcc-s1','libstdc++6','gcc-14-base','libc-bin','libc-dev-bin','libc6-dev','linux-libc-dev','libcrypt-dev','libcrypt1','zlib1g','zlib1g-dev','libssl3t64','openssl-provider-legacy','libbz2-1.0','liblzma5','libsqlite3-0','libuuid1','libexpat1','libffi8','libgomp1','libzstd1','libpcre2-8-0','libtinfo6','libncursesw6','libreadline8t64','readline-common','libmpdec4','media-types','tzdata','ca-certificates','dpkg','tar','libselinux1','libmd0','libacl1','libdebconfclient0','debconf','perl-base','libgdbm6t64','libgdbm-compat4t64','libdb5.3t64','libncurses6'}
chosen={}
def include(name):
 if name in skip:return
 if name in chosen:return
 if name not in packages:
  name=providers.get(name,name)
  if name not in packages:raise ValueError(name)
 d=packages[name];chosen[name]=d
 for entry in (d.get('Pre-Depends','')+','+d.get('Depends','')).split(','):
  alts=[re.split(r'[ :\(]',a.strip())[0] for a in entry.split('|') if a.strip()]
  if not alts:continue
  if any(a in skip for a in alts):continue
  selected=next((a for a in alts if a in packages),None) or next((providers[a] for a in alts if a in providers),None)
  if not selected:raise ValueError(entry)
  include(selected)
for n in (sys.argv[1:] or ['klayout','netgen-lvs','tcl8.6','tcl8.6-dev','tk8.6-dev','libx11-dev','libxext-dev','libxrender-dev','libxpm-dev']):include(n)
manifest=[{'package':n,'version':d['Version'],'url':'https://deb.debian.org/debian/'+d['Filename'],'file':pathlib.Path(d['Filename']).name,'sha256':d['SHA256'],'bytes':int(d['Size'])} for n,d in sorted(chosen.items())]
(root/'debian-download-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('Packages',len(manifest),'MiB',sum(d['bytes'] for d in manifest)/1024**2,flush=True)
def fetch(d):
 out=root/'downloads'/d['file']
 if not out.exists() or hashlib.sha256(out.read_bytes()).hexdigest()!=d['sha256']:
  subprocess.run(['curl','-fsSL','--retry','2','--max-time','180',d['url'],'-o',str(out)],check=True)
 assert hashlib.sha256(out.read_bytes()).hexdigest()==d['sha256'],d['file']
 print('Verified',d['package'],d['version'],flush=True)
with concurrent.futures.ThreadPoolExecutor(max_workers=6) as pool:list(pool.map(fetch,manifest))
for d in manifest:subprocess.run(['dpkg-deb','-x',str(root/'downloads'/d['file']),str(root/'debian')],check=True)
print('Extracted all packages',flush=True)
