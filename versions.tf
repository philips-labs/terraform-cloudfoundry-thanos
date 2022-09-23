terraform {
  required_version = ">= 1.3.0"

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.15.5"
    }
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.38.2"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
