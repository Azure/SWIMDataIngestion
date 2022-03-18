# KafkaServer

This cookbook provides resources for installing/configuring Apache Kafka and managing Apache Kafka service instances for use in wrapper cookbooks. Installs Apache Kafka from tarball and installs the appropriate configuration for your platform's init system. It makes all the required configuration to connect to FAA's System Wide Information System (SWIM) and connects to TFMS ( Traffic Flow Management System ) datasource.

It also shows how to use Test Kitchen in Azure in order to test your cookbook.

## Project Structure

```ssh
.
├── .delivery
├── CHANGELOG.md
├── LICENSE
├── Policyfile.rb
├── README.md
├── attributes
│   └── default.rb
├── chefignore
├── kitchen.azure.yml
├── kitchen.yml
├── metadata.rb
├── recipes
│   ├── Install.rb
│   └── default.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           ├── Install_spec.rb
│           └── default_spec.rb
├── templates
│   ├── bashrc.erb
│   ├── connect-solace-source.properties.erb
│   ├── connect-standalone.properties.erb
│   ├── kafka.service.erb
│   └── zookeeper.service.erb
└── test
    └── integration
        ├── data_bags
        │   └── connConfig
        │       └── TFMS.json
        └── default
            ├── Install_test.rb
            └── default_test.rb
```

## Requirements

### Platform Support

- RHEL 7.x
- CentOS 7.x

### Cookbook Dependencies and requirements

This cookbook uses test-kitchen `kitchen-azurerm` driver in order to run integration testing. More information about this driver can be found [here](https://github.com/test-kitchen/kitchen-azurerm)
It also assumes you have Azure CLI installed and configured and you have access to an active Azure subscription.

It comes with a `kitchen.azure.yml` test-kitchen configuration file and in order to use it you need to set the following environment variables:

```ssh
export KITCHEN_YAML=kitche.azure.yml
export SSH_KEY={{Path to the ssh key to be used in order to ssh in the VM}}
export ARM_SUBSCRIPTION_ID={{Your Azure Subscription ID}}
export RG={{The Resource Group where all the test resources are going to be stored}}
export NETWORK_RG={{The Resource Group where the network resources are. If different from the RG}}
export VNET={{VNET wehre the VM is going to be created}}
export SUBNET={{subnet where the VM is going to created}}
```

### Chef Requirements

This cookbook has been tested using

- ChefDK version: 4.13.3

## Attributes

- `default['kafkaServer']['kafkaRepo']` - Sets where Apache Kafka would be downloaded from. By default is set `https://archive.apache.org/dist/kafka/`.
- `default['kafkaServer']['kafkaVersion']` - Sets the version to be used. By defult is set to version `2.3.0`
- `default['kafkaServer']['SWIMEndpointPort']` - TFMS endpoint port. By default is set to `55443`.
- `default['kafkaServer']['SWIMVPN']` - TFMS VPN. By default is set to `TFMS`.

## Recipes

This section describes the recipes in the cookbook and how to use them in your environment.

- default - Includes the `kafkaServer::Install` recipe by default.

- Install - Installs and configures Apache Kafka, OpenJDK and all the required configurations to connect to FAA's System Wide Information System (SWIM) and connects to TFMS ( Traffic Flow Management System ) datasource.

## Usage

Simply include the `kafkaServer` cookbook wherever you would like Apache Kafka installed, such as a run list ( `-r kafkaServer` ) or a cookbook (`include_recipe 'kafkaServer'`). By default, Apache Kafka `2.3.0` is installed. The `version` attribute is used to determine which version to install, and `kafkaRepo` specifies which repository to use and by default it uses `https://archive.apache.org/dist/kafka/`.

### Example

If you are using it with knife command

```ssh
knife bootstrap [IP] -x [username] -i [ssh key] -N [Node Name] -E [environment] --sudo -r 'kafkaServer'
```

If you want to include it in a cookbook

```ruby
#metadata.rb
depends 'kafkaServer'

#in your recipe
include_recipe 'kafkaServer'
```

## Running Tests

Run integration tests

```ssh
kitchen test
```

Run unit tests.

```ssh
chef exec rspec --color
```

Static code analysis

```ssh
# Cookstyle
cookstyle --display-cop-names --extra-details
```

## Authors

Marcelo Zambrana
