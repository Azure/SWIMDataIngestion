# Chef-repo Workspace

Chef Workspace for this project that hosts all the artifacts to perform post-provsioning configurations and connect to FAA's System Wide Information System (SWIM) and connects to TFMS ( Traffic Flow Management System ) datasource.

## Chef Workspace Structure

This Chef worskapce has the following folders.

```ssh
.
├── .chef
├── cookbooks
│   └── KafkaServer
└── data_bags
    └── connConfig
```

## Knife Configuration

Knife is the [command line interface](https://docs.chef.io/workstation/knife/) for Chef. This workspace contains a .chef directory (which is a hidden directory by default) in which the knife configuration file (config.rb) is located. This file contains configuration settings for this chef workspace.

It comes with a _`config.rb`_ file. This file can be customized to support configuration settings used by [cloud provider options](https://docs.chef.io/plugin_knife/) and custom [knife plugins](https://docs.chef.io/plugin_knife_custom/).

Also located inside the .chef directory are .pem files, which contain private keys used to authenticate requests made to the Chef Infra Server. The USERNAME.pem file contains a private key unique to the user (and should never be shared with anyone). The ORGANIZATION-validator.pem file contains a private key that is global to the entire organization (and is used by all nodes and workstations that send requests to the Chef Infra Server). You can place your keys in this .chef directory.

For more information about the `config.rb` options, see the [knife](https://docs.chef.io/workstation/config_rb/) documentation.

## Cookbooks

This Chef workspace only has one cookbook _`cookbooks/KafkaServer`_ which does all the configuration needed to use Kafka and connect to FAA's System Wide Information System (SWIM) and connects to TFMS ( Traffic Flow Management System ) datasource. After making changes to this cookbook, you must upload it to the Chef Infra Server using knife:

```ssh
    knife upload cookbooks/KafkaServer
```

## Data Bags

Data bags store global variables as JSON data. Data bags are indexed for searching and can be loaded by a cookbook or accessed during a search.

This Chef Workspace has a data bag named _'connConfig'_ that contains the following list of connection information to connect to FAA's System Wide Information System (SWIM) and connects to TFMS ( Traffic Flow Management System ) datasource.

- `userName` - TFMS user name.
- `queueName` - TFMS queue name.
- `endPointJMS` - TFMS JMS end point.
- connectionFactory - TFMS JMS connection factory.
- secret - TFMS password.

You can use the _`data_bags/TFMS.json`_ template file to create the data bag in your chef server using these commands.

```ssh
knife data bag create connConfig
knife data bag from file connConfig TFMS.json
```

## Authors

- Marcelo Zambrana
