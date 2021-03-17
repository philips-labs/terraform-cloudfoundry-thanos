#!/usr/bin/env sh
set -e

# TODO this needs to be a lot more robust!
wget -O /sidecars/etc/file_sd.yml "$FILESD_URL"