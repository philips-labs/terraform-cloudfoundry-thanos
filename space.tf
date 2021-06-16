locals {
  space_id = var.cf_space_name != "" ? data.cloudfoundry_space.space[0].id : cloudfoundry_space.space[0].id
  space_name = var.cf_space_name != "" ? var.cf_space_name : cloudfoundry_space.space[0].name
}

resource "cloudfoundry_space" "space" {
  count = var.cf_space_name != "" ? 0 : 1
  name  = "thanos-${local.postfix_name}"
  org   = data.cloudfoundry_org.org.id
}

data "cloudfoundry_space" "space" {
  count = var.cf_space_name != "" ? 1 : 0
  name  = var.cf_space_name
  org   = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space_users" "users" {
  space      = local.space_id
  managers   = [data.cloudfoundry_user.user.id]
  developers = [data.cloudfoundry_user.user.id]
  auditors   = [data.cloudfoundry_user.user.id]
}
