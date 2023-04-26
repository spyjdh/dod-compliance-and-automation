control 'PHTN-40-000224' do
  title 'The Photon operating system must not respond to IPv4 Internet Control Message Protocol (ICMP) echoes sent to a broadcast address.'
  desc  'Responding to broadcast (ICMP) echoes facilitates network mapping and provides a vector for amplification attacks.'
  desc  'rationale', ''
  desc  'check', "
    At the command line, run the following command to verify ICMP echoes sent to a broadcast address are ignored:

    # /sbin/sysctl net.ipv4.icmp_echo_ignore_broadcasts

    Expected result:

    net.ipv4.icmp_echo_ignore_broadcasts = 1

    If the output does not match the expected result, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /etc/sysctl.conf

    Add or update the following line:

    net.ipv4.icmp_echo_ignore_broadcasts = 1

    At the command line, run the following command to load the new configuration:

    # /sbin/sysctl --load

    Note: If the file sysctl.conf doesn't exist it must be created.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-PHTN-40-000224'
  tag rid: 'SV-PHTN-40-000224'
  tag stig_id: 'PHTN-40-000224'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  describe kernel_parameter('net.ipv4.icmp_echo_ignore_broadcasts') do
    its('value') { should cmp 1 }
  end
end
