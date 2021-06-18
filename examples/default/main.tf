module "thanos" {
  source = "../../"

  cf_org_name   = "demo"
  cf_space_name = "test"

  enable_grafana = true
}