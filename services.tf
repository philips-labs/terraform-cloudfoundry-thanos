
resource "cloudfoundry_service_instance" "s3" {
  name         = "s3"
  space        = local.space_id
  # TODO: This needs to be driven by the CF region
  service_plan = data.cloudfoundry_service.s3.service_plans["US Standard"]
}