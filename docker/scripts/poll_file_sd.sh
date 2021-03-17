#!/usr/bin/env sh
set -e

$FILESD_URL

wget -O /sidecars/etc/file_sd.yml "$FILESD_URL"