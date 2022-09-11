terraform {
  required_version = ">= 1.2.0"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.15.5"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = ">= 1.0.3"
    }
    random = {
      source  = "random"
      version = ">= 3.4.3"
    }
  }
}
