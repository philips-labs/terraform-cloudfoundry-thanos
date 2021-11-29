terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.14.1"
    }
    random = {
      source = "random"
    }
  }
}
