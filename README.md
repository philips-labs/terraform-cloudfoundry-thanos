# Terraform Cloudfoundry Thanos module

Setup for Prometheus + Thanos on Cloudfoundry. This provides a path towards unlimited metrics storage. This module provisions
a separate Cloud foundry space and deploys a number of apps and services to provides [Thanos](https://thanos.io)

# TODO

- Internalize Prometheus

## Example of Thanos Terraform

```
module "thanos" {
    source = "github.com/philips-labs/terraform-cloudfoundry-thanos"

    cf_app_domain      = var.cf_domain
    cf_org_name        = var.cf_org
    cf_user            = var.cf_username
    enable_grafana     = true

    docker_username = var.cf_username
    docker_password = var.cf_password

    thanos_image       = "${var.docker_repo}/thanos"
    thanos_query_image = "${var.docker_repo}/thanos"
    thanos_store_image = "${var.docker_repo}/thanos"

    name_postfix       = var.name_postfix

    thanos_public_endpoints = false

    // needed for paas_prometheus_exporter
    environment = {
        USERNAME     = var.cf_username
        PASSWORD     = var.cf_password
        API_ENDPOINT = var.cf_api
    }

    // some Grafana env.vars
    grafana_environment = {
        GF_SECURITY_ADMIN_USER      = test_user
        GF_SECURITY_ADMIN_PASSWORD  = test_pass
    }
}
```

## Requirements

| Name         | Version     |
| ------------ | ----------- |
| terraform    | >= 0.13.0   |
| cloudfoundry | >= 0.1206.0 |
| random       | >= 2.2.1    |

## Providers

| Name         | Version     |
| ------------ | ----------- |
| cloudfoundry | >= 0.1206.0 |
| random       | >= 2.2.1    |

## Inputs

| Name                     | Description                                                                                                       | Type                                                                                             | Default                             | Required |
| ------------------------ | ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------ | ----------------------------------- | :------: |
| cf_app_domain            | The Cloudfoundry regular app domain to use                                                                        | `string`                                                                                         | `"us-east.philips-healthsuite.com"` |    no    |
| cf_exporter_config       | Configuration for the CloudFoundry exporter. Required if enable_cf_exporter is set to true                        | <pre>object({<br> api_endpoint = string<br> username = string<br> password = string<br> })</pre> | n/a                                 |   yes    |
| cf_org_name              | Cloudfoundry ORG name to use for reverse proxy                                                                    | `string`                                                                                         | n/a                                 |   yes    |
| cf_user                  | The Cloudfoundry user to assign rights to the app to                                                              | `string`                                                                                         | n/a                                 |   yes    |
| docker_password          | Docker registry password                                                                                          | `string`                                                                                         | `""`                                |    no    |
| docker_username          | Docker registry username                                                                                          | `string`                                                                                         | `""`                                |    no    |
| enable_cf_exporter       | Enable the CloudFoundry metrics exporter and scrape it from Thanos                                                | `bool`                                                                                           | `false`                             |    no    |
| enable_grafana           | Adds a Grafana deployment when enabled                                                                            | `bool`                                                                                           | `false`                             |    no    |
| enable_grafana_postgres  | Enables use of Postgres as Grafana config store                                                                   | `bool`                                                                                           | `true`                              |    no    |
| environment              | Pass environment variable to the app                                                                              | `map(any)`                                                                                       | `{}`                                |    no    |
| grafana_environment      | Pass environment variable to Grafana                                                                              | `map(any)`                                                                                       | `{}`                                |    no    |
| grafana_image            | Image to use for Grafana                                                                                          | `string`                                                                                         | `"grafana/grafana:latest"`          |    no    |
| grafana_public_endpoints | Make Grafana public endpoint                                                                                      | `bool`                                                                                           | `true`                              |    no    |
| name_postfix             | The postfix string to append to the space, hostname, etc. Prevents namespace clashes                              | `string`                                                                                         | `""`                                |    no    |
| thanos_disk_quota        | Thanos disk quota                                                                                                 | `number`                                                                                         | `2048`                              |    no    |
| thanos_extra_config      | Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here. | `string`                                                                                         | `""`                                |    no    |
| thanos_file_sd_url       | A URL that exposes a prometheus file_sd yaml file will be periodically downloaded and used for service discovery  | `string`                                                                                         | `""`                                |    no    |
| thanos_image             | Image to use for Thanos app. Use a v\* tagged version to prevent automatic updates                                | `string`                                                                                         | `"philipslabs/cf-thanos:latest"`    |    no    |
| thanos_memory            | Thanos memory                                                                                                     | `number`                                                                                         | `512`                               |    no    |
| thanos_public_endpoints  | Make Thanos public endpoint                                                                                       | `bool`                                                                                           | `true`                              |    no    |
| thanos_query_image       | Image to use for Thanos query. Use a v\* tagged version to prevent automatic updates                              | `string`                                                                                         | `"philipslabs/cf-thanos:latest"`    |    no    |
| thanos_store_disk_quota  | Thanos store disk quota                                                                                           | `number`                                                                                         | `2048`                              |    no    |
| thanos_store_image       | Image to use for Thanos store. Use a v\* tagged version to prevent automatic updates                              | `string`                                                                                         | `"philipslabs/cf-thanos:latest"`    |    no    |
| thanos_store_memory      | Thanos store memory                                                                                               | `number`                                                                                         | `1024`                              |    no    |

## Outputs

| Name                  | Description                                  |
| --------------------- | -------------------------------------------- |
| cluster_id            | Cluster ID of Thanos deployment              |
| grafana_app_id        | App id for Grafana                           |
| grafana_endpoint      | URL of Grafana deployment (optional)         |
| thanos_app_id         | App id for Thanos                            |
| thanos_endpoint       | URL of Thanos deployment                     |
| thanos_query_app_id   | App id for Thanos Query                      |
| thanos_query_endpoint | URL of Thanos query deployment               |
| thanos_space_id       | Cloud foundry space ID of Thanos             |
| thanos_store_app_id   | App id for Thanos Store                      |
| thanos_store_endpoint | Internal only URL of Thanos store deployment |

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel, or start a [discussion](https://github.com/philips-labs/terraform-cloudfoundry-thanos/discussions)

# License

License is MIT
