terraform {
  required_version = ">= 0.13.0"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.14.1"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
