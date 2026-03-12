from pathlib import Path
skills=Path(__file__).resolve().parents[1]/'skills'
mds=list(skills.glob('*.md'))
groups={}
for p in mds:
    name=p.name
    if '-' in name:
        prefix=name.split('-')[0]
        groups.setdefault(prefix, []).append(p)
# keep only groups with >1 file
groups={k:sorted(v,key=lambda x: x.name) for k,v in groups.items() if len(v)>1}
print('Groups found:',len(groups))
for prefix,files in sorted(groups.items()):
    dp=prefix.replace('_',' ').title()
    missing_top=[]
    missing_bottom=[]
    missing_back_top=[]
    missing_back_bottom=[]
    for f in files:
        s=f.read_text()
        lines=s.splitlines()
        top_chunk='\n'.join(lines[:60])
        bottom_chunk='\n'.join(lines[-60:])
        has_top = ('Related' in top_chunk) or ('🔗 Related' in top_chunk) or (f'Related {dp}' in s)
        has_bottom = ('## 🔗 Related' in s)
        has_back_top = '[Back to README]' in top_chunk
        has_back_bottom = '[Back to README]' in bottom_chunk
        if not has_top:
            missing_top.append(f.name)
        if not has_bottom:
            missing_bottom.append(f.name)
        if not has_back_top:
            missing_back_top.append(f.name)
        if not has_back_bottom:
            missing_back_bottom.append(f.name)
    print(f"\nGroup: {prefix} — {len(files)} files")
    if missing_top:
        print('  Missing top related in:', len(missing_top))
        for n in missing_top[:20]: print('   -', n)
    if missing_bottom:
        print('  Missing bottom related in:', len(missing_bottom))
        for n in missing_bottom[:20]: print('   -', n)
    if missing_back_top:
        print('  Missing Back-to-README at top in:', len(missing_back_top))
        for n in missing_back_top[:20]: print('   -', n)
    if missing_back_bottom:
        print('  Missing Back-to-README at bottom in:', len(missing_back_bottom))
        for n in missing_back_bottom[:20]: print('   -', n)
print('\nDone')
