# Terraform Cloudfoundry Thanos module
Experimental setup for Prometheus + Thanos on Cloudfoundry.
If this experiment pans out we will have a solution for "unlimited" metrics storage

## Requirements

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.12.4 |

## Providers

| Name | Version |
|------|---------|
| cloudfoundry | >= 0.12.4 |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_domain | The regular app domain to use | `string` | `"us-east.philips-healthsuite.com"` | no |
| org\_name | Cloudfoundry ORG name to use for reverse proxy | `string` | n/a | yes |
| thanos\_image | Image to use for Thanos app | `string` | `"loafoe/cf-thanos:0.0.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_id | Cluster ID of Tasy POC |
| thanos\_url | URL of Thanos deployment |

# Contact / Getting help
andy.lo-a-foe@philips.com

# License
License is MIT
