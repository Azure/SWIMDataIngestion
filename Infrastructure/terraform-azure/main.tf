terraform {
  backend "remote" {
    organization = "zambrana"

    workspaces {
      name = "AfG-Infra"
    }
  }
  required_version = "= 1.0.8"
  required_providers {
    azurerm = "=2.80.0"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "genericRG" {
  name     = "${var.suffix}${var.rgName}"
  location = var.location
  tags     = var.tags
}
