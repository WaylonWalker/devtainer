qm = objreg.get("quickmark-manager")
qm.marks.clear()
qm._lineparser._read()
for line in qm._lineparser:
    if not line.strip():
        continue
    qm._parse_line(line)
