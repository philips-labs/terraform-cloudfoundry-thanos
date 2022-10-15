# Terraform Cloudfoundry Thanos module

Setup for Prometheus + Thanos on Cloudfoundry. This provides a path towards unlimited metrics storage. This module deploys a number of apps and services to provide [Thanos](https://thanos.io)

## Features

- Deploys a Thanos instance with S3 Bucket as storage
- Deploys a Compactor instance
- [Variant](https://github.com/philips-software/variant) sidecar for scrape target and rule discovery
- [Remote write](#input_enable_prometheus_proxy) support

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
<!--- END_TF_DOCS --->

# Contact / Getting help

Please post your questions on the HSDP Slack `#terraform` channel, or start a [discussion](https://github.com/philips-labs/terraform-cloudfoundry-thanos/discussions)

# License

License is MIT
