control 'VCST-67-000011' do
  title "The Security Token Service must be configured to limit access to
internal packages."
  desc  "The \"package.access\" entry in the \"catalina.properties\" file
implements access control at the package level. When properly configured, a
Security Exception will be reported if an errant or malicious web app attempts
to access the listed internal classes directly or if a new class is defined
under the protected packages.

    The Security Token Service comes preconfigured with the appropriate
packages defined in \"package.access\", and this configuration must be
maintained.
  "
  desc  'rationale', ''
  desc  'check', "
    Connect to the PSC, whether external or embedded.

    At the command prompt, execute the following command:

    # grep \"package.access\"
/usr/lib/vmware-sso/vmware-sts/conf/catalina.properties

    Expected result:


package.access=sun.,org.apache.catalina.,org.apache.coyote.,org.apache.tomcat.,org.apache.jasper.

    If the output of the command does not match the expected result, this is a
finding.
  "
  desc 'fix', "
    Connect to the PSC, whether external or embedded.

    Navigate to and open
/usr/lib/vmware-sso/vmware-sts/conf/catalina.properties.

    Ensure that the \"package.access\" line is configured as follows:


package.access=sun.,org.apache.catalina.,org.apache.coyote.,org.apache.tomcat.,org.apache.jasper.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000141-WSR-000075'
  tag gid: 'V-239662'
  tag rid: 'SV-239662r816711_rule'
  tag stig_id: 'VCST-67-000011'
  tag fix_id: 'F-42854r816710_fix'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  describe command("grep 'package.access' '#{input('catalinaPropertiesPath')}'") do
    its('stdout.strip') { should eq "#{input('packageAccess')}" }
  end
end
