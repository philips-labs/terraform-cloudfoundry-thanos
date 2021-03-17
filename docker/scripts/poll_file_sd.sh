#!/usr/bin/env sh
set -e

if [ -n "$FILESD_URL" ]; then  
  echo "Polling for file_sd yaml from $FILESD_URL"
  wget -O /sidecars/etc/file_sd.yml "$FILESD_URL"
fi