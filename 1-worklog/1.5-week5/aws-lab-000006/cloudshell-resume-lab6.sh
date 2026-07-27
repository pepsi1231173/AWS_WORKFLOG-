echo RESUME_LAB6
test -f fcj_lab_state.env && cat fcj_lab_state.env || echo NO_STATE
source fcj_lab_state.env
echo DB_ENDPOINT=$DB_ENDPOINT
mysql -h "$DB_ENDPOINT" -u admin -p'123Vodanhphai' -e "ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY '123Vodanhphai'; FLUSH PRIVILEGES;" || true
if [ -x ./fcj_lab_continue.sh ]; then
  ./fcj_lab_continue.sh 2>&1 | tee fcj_lab_continue_rerun.log
else
  echo NO_CONTINUE_SCRIPT
fi
