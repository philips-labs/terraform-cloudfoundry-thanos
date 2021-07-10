# Terraform Cloudfoundry Thanos module

Setup for Prometheus + Thanos on Cloudfoundry. This provides a path towards unlimited metrics storage. This module deploys a number of apps and services to provide [Thanos](https://thanos.io)

# TODO

- Internalize Prometheus

## Example of Thanos Terraform

```
module "thanos" {
    source = "philips-labs/thanos/cloudfoundry"
    verision = "2.0.0"

    cf_org_name        = var.cf_org_name
    cf_space_name      = var.cf_space_name

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
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| cloudfoundry | >= 0.14.2 |
| hsdp | >= 0.16.3 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.14.2 |
| hsdp | >= 0.16.3 |
| random | >= 2.2.1 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [cloudfoundry_app](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/app) |
| [cloudfoundry_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/domain) |
| [cloudfoundry_network_policy](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/network_policy) |
| [cloudfoundry_org](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/org) |
| [cloudfoundry_route](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/route) |
| [cloudfoundry_service](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/data-sources/service) |
| [cloudfoundry_service_instance](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs/resources/service_instance) |
| [hsdp_config](https://registry.terraform.io/providers/philips-software/hsdp/latest/docs/data-sources/config) |
| [random_id](https://registry.terraform.io/providers/random/latest/docs/resources/id) |
| [random_password](https://registry.terraform.io/providers/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cf\_functional\_account | Configuration for the CloudFoundry function account. Required for variant and if enable\_cf\_exporter is set to true | <pre>object({<br>    api_endpoint = string<br>    username     = string<br>    password     = string<br>  })</pre> | <pre>{<br>  "api_endpoint": "",<br>  "password": "",<br>  "username": ""<br>}</pre> | no |
| cf\_org\_name | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| cf\_space\_id | Cloudfoundry SPACE id to use for deploying all Thanos components. | `string` | n/a | yes |
| docker\_password | Docker registry password | `string` | `""` | no |
| docker\_username | Docker registry username | `string` | `""` | no |
| enable\_cf\_exporter | Enable the CloudFoundry metrics exporter and scrape it from Thanos | `bool` | `false` | no |
| environment | Pass environment variable to the app | `map(any)` | `{}` | no |
| name\_postfix | The postfix string to append to the space, hostname, etc. Prevents namespace clashes | `string` | `""` | no |
| tenants | The list of tenants to scrape. When an app does not specify tenant then 'default' is used | `list(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| thanos\_disk\_quota | Thanos disk quota | `number` | `5000` | no |
| thanos\_extra\_config | Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here. | `string` | `""` | no |
| thanos\_file\_sd\_url | A URL that exposes a prometheus file\_sd yaml file will be periodically downloaded and used for service discovery | `string` | `""` | no |
| thanos\_image | Image to use for Thanos app. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v4.0.5"` | no |
| thanos\_memory | Thanos memory | `number` | `1024` | no |
| thanos\_public\_endpoints | Make Thanos public endpoint | `bool` | `false` | no |
| thanos\_query\_image | Image to use for Thanos query. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v4.0.5"` | no |
| thanos\_store\_disk\_quota | Thanos store disk quota | `number` | `5000` | no |
| thanos\_store\_image | Image to use for Thanos store. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:v4.0.5"` | no |
| thanos\_store\_memory | Thanos store memory | `number` | `1024` | no |

## Outputs

| Name | Description |
|------|-------------|
| postfix | Cluster ID / Postfix of Thanos deployment |
| thanos\_app\_id | App id for Thanos |
| thanos\_endpoint | URL of Thanos deployment |
| thanos\_query\_app\_id | App id for Thanos Query |
| thanos\_query\_endpoint | URL of Thanos query deployment |
| thanos\_space\_id | Cloud foundry space ID of Thanos |
| thanos\_store\_app\_id | App id for Thanos Store |
| thanos\_store\_endpoint | Internal only URL of Thanos store deployment |

<!--- END_TF_DOCS --->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel, or start a [discussion](https://github.com/philips-labs/terraform-cloudfoundry-thanos/discussions)

# License

License is MIT
