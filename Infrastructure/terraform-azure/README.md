# Automating Data Analytics Environments

It creates the following resources:

- A new Resource Group
- A CentOS VM
- A VNet
- A Storage Account with a container so it can be mounted in DataBricks.
- 4 subnets to host the Single Kafka VM, but in mind to create a cluster in the future.
- 2 subnets public and private dedicated to DataBricks Cluster.
- A Network Security Group with SSH, HTTP and RDP access.
- A Network Security Group dedicated to the DataBricks Cluster.
- A DataBricks Workspace with VNet injection.

## Project Structure

This project has the following files which make them easy to reuse, add or remove.

```ssh
.
├── LICENSE
├── README.md
├── main.tf
├── networking.tf
├── outputs.tf
├── security.tf
├── storage.tf
├── variables.tf
├── vm.tf
└── workspace.tf
```

Most common parameters are exposed as variables in _`variables.tf`_

## Pre-requisites

It is assumed that you have azure CLI and Terraform installed and configured.
More information on this topic [here](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure). I recommend using a Service Principal with a certificate.

### versions

This terraform script has been tested using the following versions:

- Terraform =>1.0.8
- Azure provider 2.80.0
- Azure CLI 2.29.0

## VM Authentication

It uses key based authentication and it assumes you already have a key. You can configure the path using the _sshKeyPath_ variable in _`variables.tf`_ You can create one using this command:

```ssh
ssh-keygen -t rsa -b 4096 -m PEM -C vm@mydomain.com -f ~/.ssh/vm_ssh
```

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

This terraform script uses the [cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/modules.html?highlight=chef#chef) in order to automatically bootstrap the VM and add it as node to the Chef Server which does all the required post-provisioning configuration.

## Useful Apache Kafka commands

Create a topic

```ssh
#tfms
kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic tfms
```

List topics

```ssh
kafka-topics.sh --list --bootstrap-server localhost:9092
```

Delete topics

```ssh
# tfms
kafka-topics.sh --delete --topic tfms --bootstrap-server localhost:9092
```

Describe topics

```ssh
# tfms
kafka-topics.sh --describe --topic tfms --bootstrap-server localhost:9092
```

Start standalone connection

```ssh
# tfms
connect-standalone.sh /opt/kafka/config/connect-standalone.properties /opt/kafka/config/connect-solace-tfms-source.properties
```

Check incoming messages. This command will display all the messages from the beginning and might take some time if you have lots of messages.

```ssh
# tfms
kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic tfms --from-beginning
```

If you just want to check specific messages and not display all of them, you can use the `--max-messages` option.
The following comand will display the first message.

```ssh
# tfms
kafka-console-consumer.sh --from-beginning --max-messages 1 --topic tfms --bootstrap-server localhost:9092
```

if you want to see all available options, just run the `kafka-console-consumer.sh` without any options

```ssh
kafka-console-consumer.sh
```

## Clean resources

It will destroy everything that was created.

```ssh
terraform destroy --auto-approve
```

## Caution

Be aware that by running this script your account will get billed.

## Authors

- Marcelo Zambrana
