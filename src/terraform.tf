terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.12.4"
    }
    random = {
      source = "random"
    }
  }
}
