terraform {
  backend "remote" {
    organization = "zambrana"

    workspaces {
      name = "AfG-Databricks"
    }
  }
  required_version = "= 1.5.7"
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "= 1.26.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.74.0"
    }
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
