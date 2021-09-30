# encoding: UTF-8

control 'VCLU-70-000031' do
  title 'Lookup Service must set the secure flag for cookies.'
  desc  "The secure flag is an option that can be set by the application server
when sending a new cookie to the user within an HTTP Response. The purpose of
the secure flag is to prevent cookies from being observed by unauthorized
parties due to the transmission of a the cookie in clear text.

    By setting the secure flag, the browser will prevent the transmission of a
cookie over an unencrypted channel. Lookup Service is configured to only be
accessible over a TLS tunnel but this cookie flag is still a recommended best
practice.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, execute the following command:

    # xmllint --format /usr/lib/vmware-lookupsvc/conf/web.xml | sed
's/xmlns=\".*\"//g' | xmllint --xpath
'/web-app/session-config/cookie-config/secure' -

    Expected result:

    <secure>true</secure>

    If the output of the command does not match the expected result, this is a
finding.
  "
  desc  'fix', "
    Navigate to and open:

    /usr/lib/vmware-lookupsvc/conf/web.xml

    Navigate to the /<web-apps>/<session-config>/<cookie-config> node and
configure it as follows:

        <cookie-config>
          <http-only>true</http-only>
          <secure>true</secure>
        </cookie-config>

    Restart the service with the following command:

    # vmon-cli --restart lookupsvc
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000439-WSR-000155'
  tag gid: nil
  tag rid: nil
  tag stig_id: 'VCLU-70-000031'
  tag fix_id: nil
  tag cci: ['CCI-002418']
  tag nist: ['SC-8']

  describe xml("#{input('webXmlPath')}") do
    its('/web-app/session-config/cookie-config/secure') { should cmp 'true' }
  end

end

