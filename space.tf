locals {
  space_id = data.cloudfoundry_space.space.id
  space_name = var.cf_space_name
}

data "cloudfoundry_space" "space" {
  name  = var.cf_space_name
  org   = data.cloudfoundry_org.org.id
}
