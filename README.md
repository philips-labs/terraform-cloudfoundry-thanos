# Terraform Cloudfoundry Thanos module
Experimental setup for Prometheus + Thanos on Cloudfoundry.
A path towards unlimited metrics storage. This module provisions
a separate Cloud foundry space and deploys a number of apps and services

# TODO 
- Internalize Prometheus
- Add some sort of Service Discovery to Prometheus

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

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| cloudfoundry | >= 0.1206.0 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.1206.0 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cf\_app\_domain | The Cloudfoundry regular app domain to use | `string` | `"us-east.philips-healthsuite.com"` | no |
| cf\_org\_name | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| cf\_user | The Cloudfoundry user to assign rights to the app to | `string` | n/a | yes |
| docker\_password | Docker registry password | `string` | `""` | no |
| docker\_username | Docker registry username | `string` | `""` | no |
| enable\_grafana | Adds a Grafana deployment when enabled | `bool` | `false` | no |
| enable\_grafana\_postgres | Enables use of Postgres as Grafana config store | `bool` | `true` | no |
| environment | Pass environment variable to the app | `map` | `{}` | no |
| grafana\_environment | Pass environment variable to Grafana | `map` | `{}` | no |
| grafana\_image | Image to use for Grafana | `string` | `"grafana/grafana:latest"` | no |
| name\_postfix | The postfix string to append to the space, hostname, etc. Prevents namespace clashes | `string` | n/a | yes |
| thanos\_image | Image to use for Thanos app | `string` | `"philipslabs/cf-thanos:latest"` | no |
| thanos\_query\_image | Image to use for Thanos query | `string` | `"philipslabs/cf-thanos:latest"` | no |
| thanos\_store\_image | Image to use for Thanos store | `string` | `"philipslabs/cf-thanos:latest"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | Cluster ID of Tasy POC |
| grafana\_endpoint | URL of Grafana deployment (optional) |
| thanos\_query\_endpoint | URL of Thanos deployment |

# Contact / Getting help
andy.lo-a-foe@philips.com

# License
License is MIT
