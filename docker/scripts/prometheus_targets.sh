#!/usr/bin/env sh
set -e

# Generate file to merge into actual config file
echo $PROMETHEUS_TARGETS | base64 -d >> /sidecars/etc/configured_targets.yml

# Merge the two yaml files together, overwriting prometheus.yml in place
yq m --inplace --arrays append /sidecars/etc/prometheus.yml /sidecars/etc/configured_targets.yml

# Start and run prometheus
exec /sidecars/bin/prometheus "$@"
