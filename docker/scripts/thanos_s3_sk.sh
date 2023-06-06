#!/usr/bin/env sh
set -e

cat <<EOF > /sidecars/etc/bucket_config.yaml
type: S3
config:
  bucket: "${S3_BUCKET}"
  endpoint: "${S3_ENDPOINT}"
  access_key: "${S3_API_KEY}"
  insecure: false
  signature_version2: false
  secret_key: "${S3_SECRET_KEY}"
EOF

exec /sidecars/bin/thanos "$@"
