# Terraform Cloudfoundry Thanos module
Experimental setup for Prometheus + Thanos on Cloudfoundry.
A path towards unlimited metrics storage. This module provisions
a separate Cloud foundry space and deploys a number of apps and services

# TODO 
- Add persistence and authentication to Grafana
- Internalize Prometheus
- Add some sort of Service Discovery to Prometheus

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| cloudfoundry | >= 0.12.4 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.12.4 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cf\_app\_domain | The Cloudfoundry regular app domain to use | `string` | `"us-east.philips-healthsuite.com"` | no |
| cf\_org\_name | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| cf\_user | The Cloudfoundry user to assign rights to the app to | `string` | n/a | yes |
| enable\_grafana | Adds a Grafana deployment when enabled | `bool` | `false` | no |
| grafana\_image | Image to use for Grafana | `string` | `"grafana/grafana:latest"` | no |
| thanos\_image | Image to use for Thanos app | `string` | `"loafoe/cf-thanos:0.1.0"` | no |
| thanos\_query\_image | Image to use for Thanos query | `string` | `"loafoe/cf-thanos:0.1.0"` | no |
| thanos\_store\_image | Image to use for Thanos store | `string` | `"loafoe/cf-thanos:0.1.0"` | no |
| docker\_username | Private Docker Registry username (for example AWS ECR creds) | `string` | n/a | no |
| docker\_password | Private Docker Registry password  | `string` | n/a | no |
| environment | Additional environment variables  | `Map <key>=<value>` | n/a | yes if user use cf_exporter |

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
    
    // needed for paas_prometheus_exporter
    environment = {
        USERNAME     = var.cf_username
        PASSWORD     = var.cf_password
        API_ENDPOINT = var.cf_api
    }
}
```

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
