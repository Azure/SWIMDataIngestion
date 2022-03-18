#
# Cookbook:: KafkaServer
# Spec:: Install
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'KafkaServer::Install' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7')
    runner.converge(described_recipe)
  end

  before do
    stub_data_bag_item('connConfig', 'TFMS').and_return(id: 'TFMS', userName: '', queueName: '', endPointJMS: '', connectionFactory: '', secret: '')
  end

  it 'converges successfully' do
    expect { chef_run }.to_not raise_error
  end

  it 'installs java, git and tmux' do
    expect(chef_run).to install_package 'java-1.8.0-openjdk-devel, git, tmux'
  end

  it 'creates kafkaAdmin group' do
    expect(chef_run).to create_group('kafkaAdmin')
  end

  it 'creates kafkaAdmin user' do
    expect(chef_run).to create_user('kafkaAdmin').with(
      manage_home: true,
      shell: '/bin/bash',
      group: 'kafkaAdmin',
      home: '/home/kafkaAdmin'
    )
  end

  it 'creates kafka directory' do
    expect(chef_run).to create_directory('/opt/kafka_2.12-2.3.0').with(
      group: 'kafkaAdmin'
    )
  end

  it 'gets kafka package' do
    expect(chef_run).to create_remote_file('/opt/kafka_2.12-2.3.0.tgz').with(
      source: 'https://archive.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz'
    )
  end

  it 'unpacks kafka package' do
    expect(chef_run).to run_execute('tar -xvf /opt/kafka_2.12-2.3.0.tgz -C /opt/kafka_2.12-2.3.0 --strip-components=1')
  end

  it 'creates symlink' do
    expect(chef_run).to create_link('/opt/kafka').with(
      to: '/opt/kafka_2.12-2.3.0',
      link_type: :symbolic,
      owner: 'kafkaAdmin'
    )
  end

  it 'creates porper permissions' do
    expect(chef_run).to run_execute('chown -R kafkaAdmin:kafkaAdmin /opt/kafka*')
  end

  it 'creates zookeeper.service' do
    expect(chef_run).to create_template('/etc/systemd/system/zookeeper.service').with(
      source: 'zookeeper.service.erb',
      owner: 'root',
      group: 'root'
    )
  end

  it 'creates kafka.service' do
    expect(chef_run).to create_template('/etc/systemd/system/kafka.service').with(
      source: 'kafka.service.erb',
      owner: 'root',
      group: 'root'
    )
  end

  it 'reloads systemctl' do
    expect(chef_run).to run_execute('systemctl daemon-reload')
  end

  it 'starts zookeeper service' do
    expect(chef_run).to start_service 'zookeeper'
  end

  it 'starts kafka service' do
    expect(chef_run).to start_service 'kafka'
  end

  it 'cleans temp packages' do
    expect(chef_run).to delete_file('/opt/kafka_2.12-2.3.0.tgz')
  end
end
