# Create initial Databricks notebook
resource "databricks_notebook" "tfms" {
  source = "../../Notebooks/tfms.py"
  path   = "/Shared/TFMS"
}

resource "databricks_notebook" "stdds" {
  source = "../../Notebooks/stdds.py"
  path   = "/Shared/STDDS"
}

resource "databricks_notebook" "tbfm" {
  source = "../../Notebooks/tbfm.py"
  path   = "/Shared/TBFM"
}