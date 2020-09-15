resource "cloudfoundry_space" "space" {
  name = "thanos-${random_id.id.hex}"
  org  = data.cloudfoundry_org.org.id
}

resource "cloudfoundry_space_users" "users" {
  space      = cloudfoundry_space.space.id
  managers   = [data.cloudfoundry_user.user.id]
  developers = [data.cloudfoundry_user.user.id]
  auditors   = [data.cloudfoundry_user.user.id]
}