module "thanos" {
  source = "../../"

  cf_org_name = "demo"
  cf_space_id = "test"

  grafana_password = "password"
}