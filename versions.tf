terraform {
  required_version = ">= 0.13.0"
  experiments      = [module_variable_optional_attrs]

  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">= 0.14.2"
    }
    hsdp = {
      source  = "philips-software/hsdp"
      version = ">= 0.18.1"
    }
    random = {
      source  = "random"
      version = ">= 2.2.1"
    }
  }
}
