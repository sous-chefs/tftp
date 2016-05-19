describe port(69) do
  it { should be_listening }
  its('protocols') { should eq ['udp'] }
  its('addresses') {should include '0.0.0.0'}
end

if os[:family] == 'debian'
  describe port(69) do
    its('processes') {should include 'in.tftpd'}
  end
elsif os[:family] == 'rhel'
  describe port(69) do
    its('processes') {should include 'xinetd'}
  end
end
