resource "cloudfoundry_service_instance" "s3" {
  name  = "tf-s3-thanos-${local.postfix}"
  space = var.cf_space_id
  # TODO: This needs to be driven by the CF region
  service_plan = data.cloudfoundry_service.s3.service_plans["US Standard"]
}

resource "cloudfoundry_service_key" "s3" {
  name             = "key"
  service_instance = cloudfoundry_service_instance.s3.id
}
