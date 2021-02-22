#!/usr/bin/env sh
set -e

# Generate file to merge into actual config file
echo $PROMETHEUS_TARGETS | base64 -d >> /sidecars/etc/configured_targets.yml

# Merge the two yaml files together, overwriting prometheus.yml in place
yq eval-all 'select(fileIndex == 0) * select(filename == "/sidecars/etc/configured_targets.yml")' /sidecars/etc/prometheus.yml

# Things for Cartel
json_tmpl_file="tmpl_targets"
json_file="targets.json"
echo $CARTEL_HOSTS | tr "," "\n" > hosts
echo '[{"targets": '`cat hosts| jq -R -s -c 'split("\n")[:-1]'`', "labels":{"group":"cartel"}}]'  > $json_tmpl_file
cat $json_tmpl_file | jq . > $json_file
mv $json_file /sidecars/etc/

# Start and run prometheus
exec /sidecars/bin/prometheus "$@"
