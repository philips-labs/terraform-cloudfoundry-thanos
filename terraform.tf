terraform {
  required_version = ">= 0.13.0"

  required_providers {
    cloudfoundry = {
      source  = "terraform-registry.us-east.philips-healthsuite.com/philips-forks/cloudfoundry"
      version = ">= 0.12.4"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
