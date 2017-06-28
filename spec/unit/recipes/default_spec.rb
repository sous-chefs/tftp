require 'spec_helper'

describe 'default recipe' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge('tftp::default')
  end

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
