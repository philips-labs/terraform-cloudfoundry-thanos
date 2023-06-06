module "thanos" {
  source = "../../"

  cf_space_id = "test"

  cf_functional_account = {
    api_endpoint = var.cf_api_url
    username     = var.cf_username
    password     = var.cf_password
  }
}
