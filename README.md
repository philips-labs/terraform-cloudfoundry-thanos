# Terraform Cloudfoundry Thanos module

Setup for Prometheus + Thanos on Cloudfoundry. This provides a path towards unlimited metrics storage. This module deploys a number of apps and services to provide [Thanos](https://thanos.io)

## Features

- Deploys a Thanos instance with S3 Bucket as storage
- [Variant](https://github.com/philips-software/variant) sidecar for scrape target and rule discovery

## Example of Thanos Terraform

```
module "thanos" {
    source = "philips-labs/thanos/cloudfoundry"
    version = "4.2.0"

    cf_org_name        = var.cf_org_name
    cf_space_id        = var.cf_space_id

    cf_functional_account = {
      api_endpoint = var.cf_api_url
      username     = var.cf_username
      password     = var.cf_password
    }
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_cloudfoundry"></a> [cloudfoundry](#requirement\_cloudfoundry) | >= 0.14.2 |
| <a name="requirement_hsdp"></a> [hsdp](#requirement\_hsdp) | >= 0.18.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudfoundry"></a> [cloudfoundry](#provider\_cloudfoundry) | >= 0.14.2 |
| <a name="provider_hsdp"></a> [hsdp](#provider\_hsdp) | >= 0.18.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.2.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudfoundry_app.cfpaasexporter](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.thanos](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_app.thanos_store](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) | resource |
| [cloudfoundry_network_policy.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_network_policy.thanos_store](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) | resource |
| [cloudfoundry_route.cfpaasexporter_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_query](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_query_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_route.thanos_store_internal](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) | resource |
| [cloudfoundry_service_instance.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_instance) | resource |
| [random_id.id](https://registry.terraform.io/providers/random/latest/docs/resources/id) | resource |
| [random_password.password](https://registry.terraform.io/providers/random/latest/docs/resources/password) | resource |
| [cloudfoundry_domain.app_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_domain.apps_internal_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) | data source |
| [cloudfoundry_org.org](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/org) | data source |
| [cloudfoundry_service.s3](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/service) | data source |
| [hsdp_config.cf](https://registry.terraform.io/providers/philips-software/hsdp/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alertmanagers_endpoints"></a> [alertmanagers\_endpoints](#input\_alertmanagers\_endpoints) | List of endpoints of the alert managers | `list(string)` | `[]` | no |
| <a name="input_cf_functional_account"></a> [cf\_functional\_account](#input\_cf\_functional\_account) | Configuration for the CloudFoundry function account. Required for variant and if enable\_cf\_exporter is set to true | <pre>object({<br>    api_endpoint = string<br>    username     = string<br>    password     = string<br>  })</pre> | <pre>{<br>  "api_endpoint": "",<br>  "password": "",<br>  "username": ""<br>}</pre> | no |
| <a name="input_cf_org_name"></a> [cf\_org\_name](#input\_cf\_org\_name) | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| <a name="input_cf_paas_exporter_disk_quota"></a> [cf\_paas\_exporter\_disk\_quota](#input\_cf\_paas\_exporter\_disk\_quota) | CF PaaS Exporter disk quota | `number` | `100` | no |
| <a name="input_cf_paas_exporter_image"></a> [cf\_paas\_exporter\_image](#input\_cf\_paas\_exporter\_image) | Image to use for cf paas exporter. Use a v* tagged version to prevent automatic updates | `string` | `"governmentpaas/paas-prometheus-exporter:latest"` | no |
| <a name="input_cf_paas_exporter_memory"></a> [cf\_paas\_exporter\_memory](#input\_cf\_paas\_exporter\_memory) | CF PaaS Exporter memory | `number` | `256` | no |
| <a name="input_cf_space_id"></a> [cf\_space\_id](#input\_cf\_space\_id) | Cloudfoundry SPACE id to use for deploying all Thanos components. | `string` | n/a | yes |
| <a name="input_docker_password"></a> [docker\_password](#input\_docker\_password) | Docker registry password | `string` | `""` | no |
| <a name="input_docker_username"></a> [docker\_username](#input\_docker\_username) | Docker registry username | `string` | `""` | no |
| <a name="input_enable_cf_exporter"></a> [enable\_cf\_exporter](#input\_enable\_cf\_exporter) | Enable the CloudFoundry metrics exporter and scrape it from Thanos | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Pass environment variable to the app | `map(any)` | `{}` | no |
| <a name="input_name_postfix"></a> [name\_postfix](#input\_name\_postfix) | The postfix string to append to the space, hostname, etc. Prevents namespace clashes | `string` | `""` | no |
| <a name="input_tenants"></a> [tenants](#input\_tenants) | The list of tenants to scrape. When an app does not specify tenant then 'default' is used | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_thanos_disk_quota"></a> [thanos\_disk\_quota](#input\_thanos\_disk\_quota) | Thanos disk quota | `number` | `5000` | no |
| <a name="input_thanos_extra_config"></a> [thanos\_extra\_config](#input\_thanos\_extra\_config) | Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here. | `string` | `""` | no |
| <a name="input_thanos_file_sd_url"></a> [thanos\_file\_sd\_url](#input\_thanos\_file\_sd\_url) | A URL that exposes a prometheus file\_sd yaml file will be periodically downloaded and used for service discovery | `string` | `""` | no |
| <a name="input_thanos_image"></a> [thanos\_image](#input\_thanos\_image) | Image to use for Thanos app. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v5.1.2"` | no |
| <a name="input_thanos_memory"></a> [thanos\_memory](#input\_thanos\_memory) | Thanos memory | `number` | `1024` | no |
| <a name="input_thanos_public_endpoints"></a> [thanos\_public\_endpoints](#input\_thanos\_public\_endpoints) | Make Thanos public endpoint | `bool` | `false` | no |
| <a name="input_thanos_query_image"></a> [thanos\_query\_image](#input\_thanos\_query\_image) | Image to use for Thanos query. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v5.1.2"` | no |
| <a name="input_thanos_query_service_bindings"></a> [thanos\_query\_service\_bindings](#input\_thanos\_query\_service\_bindings) | A list of service instances that should be bound to the thanos app | `list(object({ service_instance = string }))` | `[]` | no |
| <a name="input_thanos_service_bindings"></a> [thanos\_service\_bindings](#input\_thanos\_service\_bindings) | A list of service instances that should be bound to the thanos app | `list(object({ service_instance = string }))` | `[]` | no |
| <a name="input_thanos_store_disk_quota"></a> [thanos\_store\_disk\_quota](#input\_thanos\_store\_disk\_quota) | Thanos store disk quota | `number` | `5000` | no |
| <a name="input_thanos_store_image"></a> [thanos\_store\_image](#input\_thanos\_store\_image) | Image to use for Thanos store. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v5.1.2"` | no |
| <a name="input_thanos_store_memory"></a> [thanos\_store\_memory](#input\_thanos\_store\_memory) | Thanos store memory | `number` | `1536` | no |
| <a name="input_thanos_store_service_bindings"></a> [thanos\_store\_service\_bindings](#input\_thanos\_store\_service\_bindings) | A list of service instances that should be bound to the thanos\_store app | `list(object({ service_instance = string }))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postfix"></a> [postfix](#output\_postfix) | Cluster ID / Postfix of Thanos deployment |
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
