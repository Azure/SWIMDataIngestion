# Create initial Databricks notebook
resource "databricks_notebook" "ddl" {
  source = "../../Notebooks/tfms.py"
  path   = "/Shared/TFMS"
}
