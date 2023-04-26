control 'PHTN-40-000208' do
  title 'The Photon operating system must configure sshd to disable user environment processing.'
  desc  'Enabling user environment processing may enable users to bypass access restrictions in some configurations and must therefore be disabled.'
  desc  'rationale', ''
  desc  'check', "
    At the command line, run the following command to verify the running configuration of sshd:

    # sshd -T|&grep -i PermitUserEnvironment

    Expected result:

    PermitUserEnvironment no

    If there is no output or if the output does not match expected result, this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /etc/ssh/sshd_config

    Ensure the \"PermitUserEnvironment\" line is uncommented and set to the following:

    PermitUserEnvironment no

    At the command line, run the following command:

    # systemctl restart sshd.service
  "
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-OS-000480-GPOS-00229'
  tag gid: 'V-PHTN-40-000208'
  tag rid: 'SV-PHTN-40-000208'
  tag stig_id: 'PHTN-40-000208'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  sshdcommand = input('sshdcommand')
  describe command("#{sshdcommand}|&grep -i PermitUserEnvironment") do
    its('stdout.strip') { should cmp 'PermitUserEnvironment no' }
  end
end
