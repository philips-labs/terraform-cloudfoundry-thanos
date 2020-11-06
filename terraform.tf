terraform {
  required_version = ">= 0.13.0"

  required_providers {
    cloudfoundry = {
      source  = "philips-labs/cloudfoundry"
      version = ">= 0.1206.0"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
