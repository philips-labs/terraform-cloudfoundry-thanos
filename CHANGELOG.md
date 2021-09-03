# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
## v4.3.2
- Upgrade Variant to v0.0.22

## v4.3.1
- Fix invalid param

## v4.3.0
- Upgrade Variant to v0.0.21
- Initial support for prometheus rules via variant

## v4.2.0
- Update Prometheus to v2.29.2
- Reduce local storage caching
- Preparations for alert rules via variant

## v4.1.0
- Update thanos to v0.22.0

## v4.0.11
- PAAS exporter extracted from Docker image

## v4.0.10
- Update variant to v0.0.20

## v4.0.9
- Update variant to v0.0.19

## v4.0.8
- Update variant to v0.0.18

## v4.0.7
- Update variant to v0.0.17

## v4.0.6
- Update variant to v0.0.16

## v4.0.5
- Reduce build time by pulling exporter binary
- Update variant to v0.0.15

## v4.0.4
- Update variant to v0.0.14

## v4.0.3
- Update variant to v0.0.13
- Instance index is available as `${1}` for annotation `prometheus.exporter.instance_name`

## v4.0.2
- Update default images

## v4.0.1
- Update variant to v0.0.12

## v4.0.0
- BREAKING: remove Grafana from module
- NOTE: Before upgrade: `terraform state rm module.thanos.grafana_data_source.thanos`
- NOTE: Before upgrade: `terraform destroy -target=module.thanos.module.grafana`

VV v3.0.2
- Update variant to v0.0.12

## v3.0.1
- Update variant to support discovering CF instances

## v3.0.0
- Add [variant](https://github.com/philips-labs/variant) support
- Rename cf_exporter_config to more generic cf_functional_account

## v2.1.0
- Use `space_id` for Grafana integration

## v2.0.5
- Add RabbitMQ and Redis exporter injection support

## v2.0.4
- Use versioned defaults for docker images

## v2.0.3
- Upgrade to Thanos 0.21.1

## v0.9.3
- Add service discovery

## v0.9.2
- Update dependencies

## v0.9.1
- Tagged build for Docker with exporter
- Update documentation 

## v0.9.0
- Upgrade to Thanos 0.18.0 and Prometheus 2.25.0
