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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| cloudfoundry | >= 0.14.1 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.14.1 |
| random | >= 2.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| grafana | philips-labs/grafana/cloudfoundry | >= 0.5.0 |

## Resources

| Name |
|------|
| [cloudfoundry_app](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/app) |
| [cloudfoundry_domain](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/data-sources/domain) |
| [cloudfoundry_network_policy](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/network_policy) |
| [cloudfoundry_org](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/data-sources/org) |
| [cloudfoundry_route](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/route) |
| [cloudfoundry_service](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/data-sources/service) |
| [cloudfoundry_service_instance](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/service_instance) |
| [cloudfoundry_space](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/space) |
| [cloudfoundry_space_users](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/resources/space_users) |
| [cloudfoundry_user](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/0.14.1/docs/data-sources/user) |
| [random_id](https://registry.terraform.io/providers/random/2.2.1/docs/resources/id) |
| [random_password](https://registry.terraform.io/providers/random/2.2.1/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cf\_app\_domain | The Cloudfoundry regular app domain to use | `string` | `"us-east.philips-healthsuite.com"` | no |
| cf\_exporter\_config | Configuration for the CloudFoundry exporter. Required if enable\_cf\_exporter is set to true | <pre>object({<br>    api_endpoint = string<br>    username     = string<br>    password     = string<br>  })</pre> | <pre>{<br>  "api_endpoint": "",<br>  "password": "",<br>  "username": ""<br>}</pre> | no |
| cf\_org\_name | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| cf\_user | The Cloudfoundry user to assign rights to the app to | `string` | n/a | yes |
| docker\_password | Docker registry password | `string` | `""` | no |
| docker\_username | Docker registry username | `string` | `""` | no |
| enable\_cf\_exporter | Enable the CloudFoundry metrics exporter and scrape it from Thanos | `bool` | `false` | no |
| enable\_grafana | Adds a Grafana deployment when enabled | `bool` | `false` | no |
| enable\_grafana\_postgres | Enables use of Postgres as Grafana config store | `bool` | `true` | no |
| environment | Pass environment variable to the app | `map(any)` | `{}` | no |
| grafana\_environment | Pass environment variable to Grafana | `map(any)` | `{}` | no |
| grafana\_image | Image to use for Grafana | `string` | `"grafana/grafana:latest"` | no |
| grafana\_public\_endpoints | Make Grafana public endpoint | `bool` | `true` | no |
| name\_postfix | The postfix string to append to the space, hostname, etc. Prevents namespace clashes | `string` | `""` | no |
| thanos\_disk\_quota | Thanos disk quota | `number` | `2048` | no |
| thanos\_extra\_config | Any extra yaml config that will be merged into the prometheus config at runtime. Extra targets can be added here. | `string` | `""` | no |
| thanos\_file\_sd\_url | A URL that exposes a prometheus file\_sd yaml file will be periodically downloaded and used for service discovery | `string` | `""` | no |
| thanos\_image | Image to use for Thanos app. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| thanos\_memory | Thanos memory | `number` | `512` | no |
| thanos\_public\_endpoints | Make Thanos public endpoint | `bool` | `true` | no |
| thanos\_query\_image | Image to use for Thanos query. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| thanos\_store\_disk\_quota | Thanos store disk quota | `number` | `2048` | no |
| thanos\_store\_image | Image to use for Thanos store. Use a v* tagged version to prevent automatic updates | `string` | `"philipslabs/cf-thanos:latest"` | no |
| thanos\_store\_memory | Thanos store memory | `number` | `1024` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | Cluster ID of Thanos deployment |
| grafana\_app\_id | App id for Grafana |
| grafana\_endpoint | URL of Grafana deployment (optional) |
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
