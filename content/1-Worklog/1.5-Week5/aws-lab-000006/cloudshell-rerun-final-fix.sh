python3 - <<'PY'
from pathlib import Path
p = Path("fcj_lab6_resume_final.sh")
s = p.read_text()
old = 'if [[ -f fcj_lab_state.env ]]; then\n  # shellcheck disable=SC1091\n  source fcj_lab_state.env\nfi\n'
new = old + 'KEY_NAME="fcj-key-rerun"\n'
if 'KEY_NAME="fcj-key-rerun"\n\nlog()' not in s:
    s = s.replace(old, new, 1)
p.write_text(s)
PY
chmod +x fcj_lab6_resume_final.sh
./fcj_lab6_resume_final.sh 2>&1 | tee fcj_lab6_resume_final.log
