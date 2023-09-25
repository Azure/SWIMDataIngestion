terraform {
  backend "remote" {
    organization = "zambrana"

    workspaces {
      name = "AfG-Infra"
    }
  }
  required_version = "= 1.5.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.74.0"
    }
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
