control 'PHTN-67-000097' do
  title "The Photon operating system must be configured so that the /root path
is protected from unauthorized access."
  desc  "If the /root path is accessible from users other than root,
unauthorized users could change the root partitions files."
  desc  'rationale', ''
  desc  'check', "
    At the command line, execute the following command:

    # stat -c \"%n permissions are %a and owned by %U:%G\" /root

    Expected result:

    /root permissions are 700 and owned by root:root

    If the output does not match the expected result, this is a finding.
  "
  desc 'fix', "
    At the command line, execute the following commands:

    # chmod 700 /root
    # chown root:root /root
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-239168'
  tag rid: 'SV-239168r675312_rule'
  tag stig_id: 'PHTN-67-000097'
  tag fix_id: 'F-42338r675311_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  describe directory('/root') do
    its('owner') { should cmp 'root' }
    its('group') { should cmp 'root' }
    its('mode') { should cmp '0700' }
  end
end
