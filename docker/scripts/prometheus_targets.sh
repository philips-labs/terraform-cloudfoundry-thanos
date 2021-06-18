#!/usr/bin/env sh
set -e

prom_config="/sidecars/etc/prometheus.yml"

cat /sidecars/etc/prometheus.default.yml > "$prom_config"

if [ -n "$PROMETHEUS_TARGETS" ]; then  
  echo " Merging in prometheus config from PROMETHEUS_TARGETS"
  echo "$PROMETHEUS_TARGETS" | base64 -d | yq eval-all --inplace 'select(fileIndex == 0) *+ select(fileIndex == 1)' "$prom_config" -  
  cat "$prom_config"
fi

if [ -n "$FILESD_URL" ]; then  
  echo " Merging in prometheus config from file_sd"
  yq eval-all --inplace 'select(fileIndex == 0) *+ select(fileIndex == 1)' "$prom_config" /sidecars/etc/prometheus.filesd.yml
  cat "$prom_config"
fi


# only merge in the paas exporter if API_ENDPOINT is set
if [ "$ENABLE_CF_EXPORTER" = "true" ]; then  
  echo " Merging in prometheus config for paas exporter"
  yq eval-all --inplace 'select(fileIndex == 0) *+ select(fileIndex == 1)' "$prom_config" /sidecars/etc/prometheus.paasexporter.yml
  cat "$prom_config"
fi

# only merge in the cartel stuff if CARTEL_HOSTS is set
if [ -n "$CARTEL_HOSTS" ]; then  
  echo " Merging in prometheus config for cartel endpoints"
  json_tmpl_file="tmpl_targets"
  json_file="targets.json"
  echo "$CARTEL_HOSTS" | tr "," "\n" > hosts
  echo '[{"targets": '$(cat hosts| jq -R -s -c 'split("\n")[:-1]')', "labels":{"group":"cartel"}}]'  > $json_tmpl_file
  cat $json_tmpl_file | jq . > $json_file
  mv $json_file /sidecars/etc/
  yq eval-all --inplace 'select(fileIndex == 0) *+ select(fileIndex == 1)' "$prom_config" /sidecars/etc/prometheus.cartel.yml
  cat "$prom_config"
fi

if [ -n "$PG_EXPORTERS" ]; then
  echo " Merging pg_exporter list"
  json_tmpl_file="tmpl_targets"
  json_file="pgexporters.json"
  echo "$PG_EXPORTERS" | tr "," "\n" > exporters
  echo '[{"targets": '$(cat exporters| jq -R -s -c 'split("\n")[:-1]')', "labels":{"group":"pg_exporter"}}]'  > $json_tmpl_file
  cat $json_tmpl_file | jq . > $json_file
  mv $json_file /sidecars/etc/
  yq eval-all --inplace 'select(fileIndex == 0) *+ select(fileIndex == 1)' "$prom_config" /sidecars/etc/prometheus.pgexporter.yml
  cat "$prom_config"
fi

# Start and run prometheus
exec /sidecars/bin/prometheus --config.file="$prom_config" --storage.tsdb.path=/prometheus --storage.tsdb.retention=2d --storage.tsdb.min-block-duration=30m --storage.tsdb.max-block-duration=30m --web.enable-lifecycle
