terraform {
  backend "remote" {
    organization = "zambrana"

    workspaces {
      name = "AfG-Databricks"
    }
  }
  required_version = "= 1.0.8"
  required_providers {
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.3.5"
    }
    azurerm = "=2.80.0"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_databricks_workspace" "databricksWokspace" {
  name                = "${var.suffix}${var.workspaceName}"
  resource_group_name = "${var.suffix}${var.rgName}"
}

provider "databricks" {
  azure_workspace_resource_id = data.azurerm_databricks_workspace.databricksWokspace.id
}
