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
<!--- END_TF_DOCS --->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel, or start a [discussion](https://github.com/philips-labs/terraform-cloudfoundry-thanos/discussions)

# License

License is MIT
