#
# Cookbook:: KafkaServer
# Recipe:: Install
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# package %w(java-1.8.0-openjdk-devel git tmux) do
package %w(java-11-openjdk-devel git tmux) do
  action :install
end

group 'kafkaAdmin'

user 'kafkaAdmin' do
  # use manage_home false when usign terraform to provision infrastructure and the initial username is also kafkaAdmin.
  # manage_home false
  manage_home true
  # shell '/bin/nologin'
  shell '/bin/bash'
  group 'kafkaAdmin'
  home '/home/kafkaAdmin'
  action :create
end

template 'Custom bashrc' do
  path '/home/kafkaAdmin/.bashrc'
  source 'bashrc.erb'
  owner 'kafkaAdmin'
  group 'kafkaAdmin'
end

# kafka_2.12-2.3.0
package_name = "kafka_2.12-#{node['kafkaServer']['kafkaVersion']}"

# https://archive.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz
package_path = "#{node['kafkaServer']['kafkaRepo']}#{node['kafkaServer']['kafkaVersion']}/#{package_name}.tgz"

# /opt/kafka_2.12-2.3.0.tgz
local_path = "/opt/#{package_name}.tgz"

directory 'kafkaDirectory' do
  path "/opt/#{package_name}"
  group 'kafkaAdmin'
  action :create
end

remote_file 'kafkaPackage' do
  path local_path
  source package_path
  action :create
end

# tar -xvf /opt/kafka_2.12-2.3.0.tgz -C /opt/kafka_2.12-2.3.0 --strip-components=1
execute 'untarKafka' do
  command "tar -xvf #{local_path} -C /opt/#{package_name} --strip-components=1"
  action :run
end

link 'kafkaSymLink' do
  target_file '/opt/kafka'
  to "/opt/#{package_name}"
  link_type :symbolic
  owner 'kafkaAdmin'
  action :create
end

execute 'kafkaPermissions' do
  command 'chown -R kafkaAdmin:kafkaAdmin /opt/kafka*'
  action :run
end

# https://solaceproducts.github.io/pubsubplus-connector-kafka-source/downloads/pubsubplus-connector-kafka-source-2.1.0.zip
remote_file 'Solace Connector' do
  path '/tmp/solace-connector.zip'
  source "https://solaceproducts.github.io/pubsubplus-connector-kafka-source/downloads/pubsubplus-connector-kafka-source-#{node['kafkaServer']['solaceCoonector']}.zip"
  action :create
end

archive_file 'Unpack Solace Connector and its Dependencies' do
  owner 'kafkaAdmin'
  group 'kafkaAdmin'
  path '/tmp/solace-connector.zip'
  destination '/tmp/solace-connector'
  action :extract
end

execute 'Copy Solace Connector and its Dependencies' do
  command "mv /tmp/solace-connector/pubsubplus-connector-kafka-source-#{node['kafkaServer']['solaceCoonector']}/lib/*.jar /opt/kafka/libs/"
  action :run
  not_if { ::File.exist?("/opt/kafka/libs/pubsubplus-connector-kafka-source-#{node['kafkaServer']['solaceCoonector']}.jar") }
end

template 'Configure Solace Connector in Stand Alone mode' do
  source 'connect-standalone.properties.erb'
  path '/opt/kafka/config/connect-standalone.properties'
end

TFMSConfig = data_bag_item('connConfig', 'TFMS')
TBFMConfig = data_bag_item('connConfig', 'TBFM')
STDDSConfig = data_bag_item('connConfig', 'STDDS')

template 'Configure TFMS Source Connector' do
  source 'connect-solace-source.properties.erb'
  path '/opt/kafka/config/connect-solace-tfms-source.properties'
  variables(
    connectorName: 'solaceConnectorTFMS',
    kafkaTopic: 'tfms',
    SWIMEndpoint: TFMSConfig['endPointJMS'],
    SWIMUserNaMe: TFMSConfig['userName'],
    Password: TFMSConfig['secret'],
    SWIMQueue: TFMSConfig['queueName'],
    SWIMVPN: TFMSConfig['vpn']
  )
end

template 'Configure TBFM Source Connector' do
  source 'connect-solace-source.properties.erb'
  path '/opt/kafka/config/connect-solace-tbfm-source.properties'
  variables(
    connectorName: 'solaceConnectorTBFM',
    kafkaTopic: 'tbfm',
    SWIMEndpoint: TBFMConfig['endPointJMS'],
    SWIMUserNaMe: TBFMConfig['userName'],
    Password: TBFMConfig['secret'],
    SWIMQueue: TBFMConfig['queueName'],
    SWIMVPN: TBFMConfig['vpn']
  )
end

template 'Configure STDDS Source Connector' do
  source 'connect-solace-source.properties.erb'
  path '/opt/kafka/config/connect-solace-stdds-source.properties'
  variables(
    connectorName: 'solaceConnectorSTDDS',
    kafkaTopic: 'stdds',
    SWIMEndpoint: STDDSConfig['endPointJMS'],
    SWIMUserNaMe: STDDSConfig['userName'],
    Password: STDDSConfig['secret'],
    SWIMQueue: STDDSConfig['queueName'],
    SWIMVPN: STDDSConfig['vpn']
  )
end

template 'zookeeperTemplate' do
  source 'zookeeper.service.erb'
  path '/etc/systemd/system/zookeeper.service'
  owner 'root'
  group 'root'
  action :create
end

template 'kafkaTemplate' do
  source 'kafka.service.erb'
  path '/etc/systemd/system/kafka.service'
  owner 'root'
  group 'root'
  action :create
end

execute 'reloadService' do
  command 'systemctl daemon-reload'
  action :run
end

service 'zookeeperService' do
  service_name 'zookeeper'
  action [:enable, :start]
end

service 'kafkaService' do
  service_name 'kafka'
  action [:enable, :start]
end

execute 'Create TFMS topic' do
  command '/opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic tfms'
  action :run
  not_if { ::Dir.exist?('/tmp/kafka-logs/tfms-0') }
end

execute 'Create TBFM topic' do
  command '/opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic tbfm'
  action :run
  not_if { ::Dir.exist?('/tmp/kafka-logs/tbfm-0') }
end

execute 'Create STDDS topic' do
  command '/opt/kafka/bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic stdds'
  action :run
  not_if { ::Dir.exist?('/tmp/kafka-logs/stdds-0') }
end

file 'clean' do
  path local_path
  action :delete
end

directory 'Clean solace connector' do
  path '/tmp/solace-connector'
  recursive true
  action :delete
end

file 'Clean solace connector zip' do
  path '/tmp/solace-connector.zip'
  action :delete
end
