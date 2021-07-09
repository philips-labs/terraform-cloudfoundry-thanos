provider "cloudfoundry" {
  api_url             = var.cf_api_url
  user                = var.cf_username
  password            = var.cf_password
  skip_ssl_validation = false
}

provider "hsdp" {
  region = "us-east"
}
