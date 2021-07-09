# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).
## v4.0.0
- BREAKING: remove Grafana from module
- NOTE: Before upgrade: `terraform state rm module.thanos.grafana_data_source.thanos`
- NOTE: Before upgrade: `terraform destroy -target=module.thanos.module.grafana`


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
