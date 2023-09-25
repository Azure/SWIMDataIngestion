# Automating Data Analytics Environments

It creates the following resources:

- A DataBricks Cluster.
- A starter Notebook with initial python code to connect to Kafka.

## Project Structure

This project has the following files which make them easy to reuse, add or remove.

```ssh
.
├── LICENSE
├── README.md
├── clusters.tf
├── main.tf
├── notebooks.tf
├── outputs.tf
└── variables.tf
```

Most common parameters are exposed as variables in _`variables.tf`_

## Pre-requisites

It is assumed that you have azure CLI and Terraform installed and configured.
More information on this topic [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure). I recommend using a Service Principal with a certificate.

### versions

This terraform script has been tested using the following versions:

- Terraform =>1.5.7
- Azure provider 3.74.0
- Databricks provider 1.26.0
- Azure CLI 2.52.0

## Usage

Just run these commands to initialize terraform, get a plan and approve it to apply it.

```ssh
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

I also recommend using a remote state instead of a local one. You can change this configuration in _`main.tf`_
You can create a free Terraform Cloud account [here](https://app.terraform.io).

## Clean resources

It will destroy everything that was created.

```ssh
terraform destroy --auto-approve
```

## Caution

Be aware that by running this script your account will get billed.

## Authors

- Marcelo Zambrana
