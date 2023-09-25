#
# Cookbook:: KafkaServer
# Spec:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'KafkaServer::default' do
  context 'When all attributes are default, on CentOS 7' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'centos', '7'

    before do
      stub_data_bag_item('connConfig', 'TFMS').and_return(id: 'TFMS', userName: '', queueName: '', endPointJMS: '', connectionFactory: '', secret: '', vpn: '')

      stub_data_bag_item('connConfig', 'TBFM').and_return(id: 'TBFM', userName: '', queueName: '', endPointJMS: '', connectionFactory: '', secret: '', vpn: '')

      stub_data_bag_item('connConfig', 'STDDS').and_return(id: 'STDDS', userName: '', queueName: '', endPointJMS: '', connectionFactory: '', secret: '', vpn: '')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
