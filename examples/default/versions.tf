terraform {
  required_providers {
    cloudfoundry = {
      source = "cloudfoundry-community/cloudfoundry"
    }
    grafana = {
      source  = "grafana/grafana"
      version = ">= 1.11.0"
    }
  }
}