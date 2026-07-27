python3 - <<'PY'
from pathlib import Path
p = Path("fcj_lab_create.sh")
s = p.read_text()
needle = 'record DB_ENDPOINT "$DB_ENDPOINT"\n'
insert = '''record DB_ENDPOINT "$DB_ENDPOINT"
log "Configuring MySQL native password auth for Node mysql client"
mysql -h "$DB_ENDPOINT" -u "$DB_USER" -p"$DB_PASS" -e "ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY '123Vodanhphai'; FLUSH PRIVILEGES;"
'''
if "Configuring MySQL native password auth" not in s:
    if needle not in s:
        raise SystemExit("needle not found")
    s = s.replace(needle, insert, 1)
    p.write_text(s)
print("PATCHED_CREATE_AUTH")
PY
