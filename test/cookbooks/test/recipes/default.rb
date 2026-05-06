# frozen_string_literal: true

tftp_server 'default' do
  directory node['tftp_test']['directory']
  directory_mode node['tftp_test']['directory_mode']
  username node['tftp_test']['username']
  address node['tftp_test']['address']
  options node['tftp_test']['options']
  action :create
end
