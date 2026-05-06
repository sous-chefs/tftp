# frozen_string_literal: true

require 'spec_helper'

describe 'tftp_server' do
  step_into :tftp_server

  context 'on ubuntu' do
    platform 'ubuntu', '24.04'

    context 'with default properties' do
      recipe do
        tftp_server 'default'
      end

      it { is_expected.to install_package(%w(tftpd-hpa)) }

      it do
        is_expected.to create_directory('/var/lib/tftpboot').with(
          owner: 'root',
          group: 'nogroup',
          mode: '0755',
          recursive: true
        )
      end

      it do
        is_expected.to create_template('/etc/default/tftpd-hpa').with(
          source: 'tftp.erb',
          owner: 'root',
          group: 'root',
          mode: '0644',
          variables: {
            config_file: '/etc/default/tftpd-hpa',
            conf: {
              TFTP_USERNAME: 'tftp',
              TFTP_DIRECTORY: '/var/lib/tftpboot',
              TFTP_ADDRESS: '0.0.0.0:69',
              TFTP_OPTIONS: '--secure',
              RUN_DAEMON: 'yes',
              OPTIONS: '-s',
            },
          }
        )
      end

      it { is_expected.to enable_service('tftpd-hpa') }
      it { is_expected.to start_service('tftpd-hpa') }
    end

    context 'with custom properties' do
      recipe do
        tftp_server 'custom' do
          directory '/srv/tftp'
          directory_mode '0750'
          username 'nobody'
          address '127.0.0.1:1069'
          options '--secure --create'
        end
      end

      it do
        is_expected.to create_directory('/srv/tftp').with(
          owner: 'root',
          group: 'nogroup',
          mode: '0750'
        )
      end

      it { is_expected.to render_file('/etc/default/tftpd-hpa').with_content('TFTP_USERNAME="nobody"') }
      it { is_expected.to render_file('/etc/default/tftpd-hpa').with_content('TFTP_DIRECTORY="/srv/tftp"') }
      it { is_expected.to render_file('/etc/default/tftpd-hpa').with_content('TFTP_ADDRESS="127.0.0.1:1069"') }
      it { is_expected.to render_file('/etc/default/tftpd-hpa').with_content('TFTP_OPTIONS="--secure --create"') }
    end

    context 'with action delete' do
      recipe do
        tftp_server 'default' do
          action :delete
        end
      end

      it { is_expected.to stop_service('tftpd-hpa') }
      it { is_expected.to disable_service('tftpd-hpa') }
      it { is_expected.to delete_file('/etc/default/tftpd-hpa') }
      it { is_expected.to delete_directory('/var/lib/tftpboot').with(recursive: true) }
      it { is_expected.to remove_package(%w(tftpd-hpa)) }
    end
  end

  context 'on almalinux' do
    platform 'almalinux', '9'

    context 'with default properties' do
      recipe do
        tftp_server 'default'
      end

      it { is_expected.to install_package(%w(tftp-server)) }

      it do
        is_expected.to create_directory('/var/lib/tftpboot').with(
          owner: 'root',
          group: 'root',
          mode: '0755',
          recursive: true
        )
      end

      it { is_expected.to create_directory('/etc/systemd/system/tftp.service.d') }

      it do
        is_expected.to create_template('/etc/systemd/system/tftp.service.d/10-override.conf').with(
          source: '10-override.conf.erb',
          variables: { directory: '/var/lib/tftpboot' }
        )
      end

      it { is_expected.to_not run_execute('systemctl daemon-reload') }
      it { is_expected.to enable_service('tftp.socket') }
      it { is_expected.to start_service('tftp.socket') }
    end

    context 'with action delete' do
      recipe do
        tftp_server 'default' do
          action :delete
        end
      end

      it { is_expected.to stop_service('tftp.socket') }
      it { is_expected.to disable_service('tftp.socket') }
      it { is_expected.to delete_file('/etc/systemd/system/tftp.service.d/10-override.conf') }
      it { is_expected.to delete_directory('/etc/systemd/system/tftp.service.d').with(recursive: true) }
      it { is_expected.to delete_directory('/var/lib/tftpboot').with(recursive: true) }
      it { is_expected.to remove_package(%w(tftp-server)) }
    end
  end
end
