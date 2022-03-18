# InSpec test for recipe KafkaServer::Install

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

%w(java-1.8.0-openjdk-devel git tmux).each do |package|
  describe package(package) do
    it { should be_installed }
  end
end

describe group('kafkaAdmin') do
  it { should exist }
end

describe user('kafkaAdmin') do
  it { should exist }
  its('group') { should eq 'kafkaAdmin' }
end

describe file('/etc/systemd/system/zookeeper.service') do
  it { should exist }
end

describe file('/etc/systemd/system/kafka.service') do
  it { should exist }
end

describe service('zookeeper') do
  it { should be_enabled }
  it { should be_running }
end

describe service('kafka') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/opt/kafka/libs/pubsubplus-connector-kafka-source-2.1.0.jar') do
  it { should exist }
end

describe file('/opt/kafka/config/connect-standalone.properties') do
  it { should exist }
end

describe file('/opt/kafka/config/connect-solace-tfms-source.properties') do
  it { should exist }
end
