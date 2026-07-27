sed -i 's/KEY_NAME="${KEY_NAME:-fcj-key}"/KEY_NAME="fcj-key-rerun"/' fcj_lab6_rest.sh
grep 'KEY_NAME=' fcj_lab6_rest.sh | head
./fcj_lab6_rest.sh 2>&1 | tee fcj_lab6_rest_rerun.log
