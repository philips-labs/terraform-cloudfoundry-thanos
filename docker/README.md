# Build Prometheus/Thanos Docker image

This is the customised image for Prometheus with some includes extras for running in CloudFoundry and enabling Thanos functionality with S3.

In this image we include

- Prometheus
- Thanos
- paas-prometheus-exporter based on https://github.com/alphagov/paas-prometheus-exporter
- URL based file service discovery

## Customising Thanos

It is currently not possible to customise the config of Thanos. This can be added by customising `thanos.conf`.

For example.
You can add these parameters and make them customisable

```bash
--storage.tsdb.min-block-duration=30m --storage.tsdb.max-block-duration=30m
```

## paas-prometheus-exporter

This is an prometheus exporter that runs to export metrics from a CloudFoundry instance. You can find more info at the upstream config

Generally you will just need the following environment variable set

| Configuration Option | Application Flag | Environment Variable |
| :------------------- | :--------------- | :------------------- |
| API endpoint         | api-endpoint     | API_ENDPOINT         |
| Username             | username         | USERNAME             |
| Password             | password         | PASSWORD             |

## How to supplement prometheus config

To enable the addition of more prometheus config you can add bse64 encoded yaml content to the environment variable `PROMETHEUS_TARGETS`. This is then decoded and merged into the main prometheus.yml using `yq`.

## URL based file_sd for prometheus

This image can accept a URL that is passed on `FILESD_URL` which it will periodically poll and save to to the file `/sidecars/etc/file_sd.yml`.

The default `prometheus.yml` includes the config to read this file and configure any scrape targets that are in it.
