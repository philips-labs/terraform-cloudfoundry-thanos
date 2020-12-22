json_tmpl_file="tmpl_targers"
json_file="targets.json"
echo $CARTEL_HOSTS | tr "," "\n" > hosts
echo '[{"targets": '`cat hosts| jq -R -s -c 'split("\n")[:-1]'`', "labels":{"group":"cartel"}}]'  > $json_tmpl_file
cat $json_tmpl_file | jq . > $json_file
mv $json_file /sidecars/etc/
exec /sidecars/bin/prometheus "$@"