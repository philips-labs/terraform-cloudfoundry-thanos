# Terraform Cloudfoundry Thanos module

Setup for Prometheus + Thanos on Cloudfoundry. This provides a path towards unlimited metrics storage. This module provisions
a separate Cloud foundry space and deploys a number of apps and services to provides [Thanos](https://thanos.io)

# TODO

- Internalize Prometheus

## Example of Thanos Terraform

```
module "thanos" {
    source = "philips-labs/thanos/cloudfoundry"
    verision = "2.0.0"

    cf_org_name        = var.cf_org_name
    cf_space_name      = var.cf_space_name
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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_cloudfoundry"></a> [cloudfoundry](#requirement\_cloudfoundry) | >= 0.14.2 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | >= 1.11.0 |
| <a name="requirement_hsdp"></a> [hsdp](#requirement\_hsdp) | >= 0.16.3 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudfoundry"></a> [cloudfoundry](#provider\_cloudfoundry) | >= 0.14.2 |
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | >= 1.11.0 |
| <a name="provider_hsdp"></a> [hsdp](#provider\_hsdp) | >= 0.16.3 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana"></a> [grafana](#module\_grafana) | philips-labs/grafana/cloudfoundry | 0.8.3 |

## Resources

| Name | Type |
|------|------|
| [cloudfoundry_app.thanos](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.thanos_store](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_network_policy.grafana_database_metrics](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_network_policy.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_network_policy.thanos_store](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_route.thanos](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_query_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_store_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_service_instance.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_instance) | resource |
| [grafana_data_source.thanos](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [random_id.id](https://registry.terraform.io/providers/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/random/latest/docs/resources/password) | resource |
| [cloudfoundry_domain.app_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_domain.apps_internal_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_org.org](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/org) | data source |
| [cloudfoundry_service.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/service) | data source |
| [cloudfoundry_space.space](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/space) | data source |
| [hsdp_config.cf](https://registry.terraform.io/providers/philips-software/hsdp/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cf_exporter_config"></a> [cf\_exporter\_config](#input\_cf\_exporter\_config) | Configuration for the CloudFoundry exporter. Required if enable\_cf\_exporter is set to true | <pre>object({<br>    api_endpoint = string<br>    username     = string<br>    password     = string<br>  })</pre> | <pre>{<br>  "api_endpoint": "",<br>  "password": "",<br>  "username": ""<br>}</pre> | no |
| <a name="input_cf_org_name"></a> [cf\_org\_name](#input\_cf\_org\_name) | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| <a name="input_cf_space_name"></a> [cf\_space\_name](#input\_cf\_space\_name) | Cloudfoundry SPACE name to use for deploying all Thanos components. If empty, the module will create it's own space | `string` | n/a | yes |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | Docker registry password | `string` | `""` | no |
| <a name="input_docker_username"></a> [docker\_username](#input\_docker\_username) | Docker registry username | `string` | `""` | no |
| <a name="input_enable_cf_exporter"></a> [enable\_cf\_exporter](#input\_enable\_cf\_exporter) | Enable the CloudFoundry metrics exporter and scrape it from Thanos | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Pass environment variable to the app | `map(any)` | `{}` | no |
| <a name="input_grafana_environment"></a> [grafana\_environment](#input\_grafana\_environment) | Pass environment variable to Grafana | `map(any)` | `{}` | no |
| <a name="input_grafana_image"></a> [grafana\_image](#input\_grafana\_image) | Image to use for Grafana | `string` | `"grafana/grafana:latest"` | no |
| <a name="input_grafana_password"></a> [grafana\_password](#input\_grafana\_password) | Grafana password | `string` | n/a | yes |
| <a name="input_grafana_public_endpoints"></a> [grafana\_public\_endpoints](#input\_grafana\_public\_endpoints) | Make Grafana public endpoint | `bool` | `true` | no |
| <a name="input_grafana_username"></a> [grafana\_username](#input\_grafana\_username) | Grafana username | `string` | `"admin"` | no |
| <a name="input_name_postfix"></a> [name\_postfix](#input\_name\_postfix) | The postfix string to append to the space, hostname, etc. Prevents namespace clashes | `string` | `""` | no |
| <a name="input_thanos_disk_quota"></a> [thanos\_disk\_quota](#input\_thanos\_disk\_quota) | Thanos disk quota | `number` | `2048` | no |
| <a name="input_thanos_extra_config"></a> [thanos\_extra\_config](#input\_thanos\_extra\_config) | Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here. | `string` | `""` | no |
| <a name="input_thanos_file_sd_url"></a> [thanos\_file\_sd\_url](#input\_thanos\_file\_sd\_url) | A URL that exposes a prometheus file\_sd yaml file will be periodically downloaded and used for service discovery | `string` | `""` | no |
| <a name="input_thanos_image"></a> [thanos\_image](#input\_thanos\_image) | Image to use for Thanos app. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| <a name="input_thanos_memory"></a> [thanos\_memory](#input\_thanos\_memory) | Thanos memory | `number` | `512` | no |
| <a name="input_thanos_public_endpoints"></a> [thanos\_public\_endpoints](#input\_thanos\_public\_endpoints) | Make Thanos public endpoint | `bool` | `true` | no |
| <a name="input_thanos_query_image"></a> [thanos\_query\_image](#input\_thanos\_query\_image) | Image to use for Thanos query. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| <a name="input_thanos_store_disk_quota"></a> [thanos\_store\_disk\_quota](#input\_thanos\_store\_disk\_quota) | Thanos store disk quota | `number` | `2048` | no |
| <a name="input_thanos_store_image"></a> [thanos\_store\_image](#input\_thanos\_store\_image) | Image to use for Thanos store. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| <a name="input_thanos_store_memory"></a> [thanos\_store\_memory](#input\_thanos\_store\_memory) | Thanos store memory | `number` | `1024` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster ID of Thanos deployment |
| <a name="output_grafana_app_id"></a> [grafana\_app\_id](#output\_grafana\_app\_id) | App id for Grafana |
| <a name="output_grafana_auth"></a> [grafana\_auth](#output\_grafana\_auth) | The Grafana auth token to use for e.g. configuring Grafana provider |
| <a name="output_grafana_endpoint"></a> [grafana\_endpoint](#output\_grafana\_endpoint) | URL of Grafana deployment (optional) |
| <a name="output_grafana_url"></a> [grafana\_url](#output\_grafana\_url) | The Grafana URL |
| <a name="output_thanos_app_id"></a> [thanos\_app\_id](#output\_thanos\_app\_id) | App id for Thanos |
| <a name="output_thanos_endpoint"></a> [thanos\_endpoint](#output\_thanos\_endpoint) | URL of Thanos deployment |
| <a name="output_thanos_query_app_id"></a> [thanos\_query\_app\_id](#output\_thanos\_query\_app\_id) | App id for Thanos Query |
| <a name="output_thanos_query_endpoint"></a> [thanos\_query\_endpoint](#output\_thanos\_query\_endpoint) | URL of Thanos query deployment |
| <a name="output_thanos_space_id"></a> [thanos\_space\_id](#output\_thanos\_space\_id) | Cloud foundry space ID of Thanos |
| <a name="output_thanos_store_app_id"></a> [thanos\_store\_app\_id](#output\_thanos\_store\_app\_id) | App id for Thanos Store |
| <a name="output_thanos_store_endpoint"></a> [thanos\_store\_endpoint](#output\_thanos\_store\_endpoint) | Internal only URL of Thanos store deployment |
<!--- END_TF_DOCS --->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel, or start a [discussion](https://github.com/philips-labs/terraform-cloudfoundry-thanos/discussions)

# License

License is MIT
