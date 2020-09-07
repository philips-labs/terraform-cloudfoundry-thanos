#!/usr/bin/env sh
set -e

S3_BUCKET=$(echo $VCAP_SERVICES | jq -r '.["hsdp-s3"][0]'.credentials.bucket)
S3_ENDPOINT=$(echo $VCAP_SERVICES | jq -r '.["hsdp-s3"][0]'.credentials.endpoint)
S3_API_KEY=$(echo $VCAP_SERVICES | jq -r '.["hsdp-s3"][0]'.credentials.api_key)
S3_SECRET_KEY=$(echo $VCAP_SERVICES | jq -r '.["hsdp-s3"][0]'.credentials.secret_key)
S3_URI=$(echo $VCAP_SERVICES | jq -r '.["hsdp-s3"][0]'.credentials.uri)

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
