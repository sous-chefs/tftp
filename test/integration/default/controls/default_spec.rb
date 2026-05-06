# frozen_string_literal: true

title 'tftp_server default resource'

control 'tftp-package-01' do
  impact 1.0
  title 'TFTP server package is installed'

  if os.debian?
    describe package('tftpd-hpa') do
      it { should be_installed }
    end
  else
    describe package('tftp-server') do
      it { should be_installed }
    end
  end
end

control 'tftp-directory-01' do
  impact 1.0
  title 'TFTP root directory is managed'

  describe directory('/var/lib/tftpboot') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('mode') { should cmp '0755' }
  end
end

control 'tftp-service-01' do
  impact 1.0
  title 'TFTP service is enabled and running'

  if os.debian?
    describe service('tftpd-hpa') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/etc/default/tftpd-hpa') do
      it { should exist }
      its('content') { should match(%r{TFTP_DIRECTORY="/var/lib/tftpboot"}) }
      its('content') { should match(/TFTP_OPTIONS="--secure"/) }
    end
  else
    describe service('tftp.socket') do
      it { should be_enabled }
      it { should be_running }
    end

    describe file('/etc/systemd/system/tftp.service.d/10-override.conf') do
      it { should exist }
      its('content') { should match(%r{ExecStart=/usr/sbin/in.tftpd -s /var/lib/tftpboot}) }
    end
  end
end
