control 'T0RT-3X-000084' do
  title 'The NSX-T Tier-0 Gateway must be configured to use its loopback address as the source address for iBGP peering sessions.'
  desc 'Using a loopback address as the source address offers a multitude of uses for security, access, management, and scalability of the BGP routers. It is easier to construct appropriate ingress filters for router management plane traffic destined to the network management subnet since the source addresses will be from the range used for loopback interfaces instead of a larger range of addresses used for physical interfaces. Log information recorded by authentication and syslog servers will record the router’s loopback address instead of the numerous physical interface addresses.

When the loopback address is used as the source for eBGP peering, the BGP session will be harder to hijack since the source address to be used is not known globally—making it more difficult for a hacker to spoof an eBGP neighbor. By using traceroute, a hacker can easily determine the addresses for an eBGP speaker when the IP address of an external interface is used as the source address. The routers within the iBGP domain should also use loopback addresses as the source address when establishing BGP sessions.'
  desc 'check', 'If the Tier-0 Gateway is not using iBGP, this is Not Applicable.

From the NSX-T Manager web interface, go to Networking >> Tier-0 Gateways.

For every Tier-0 Gateway with BGP enabled, expand the Tier-0 Gateway.

Expand BGP, click on the number next to BGP Neighbors, then view the source address for each neighbor.

If the Source Address is not configured as the NSX-T Tier-0 Gateway loopback address for the iBGP session, this is a finding.'
  desc 'fix', 'To configure a loopback interface do the following:

From the NSX-T Manager web interface, go to Networking >> Tier-0 Gateways and expand the target Tier-0 gateway.

Expand interfaces and click "Add Interface".

Enter a name, select "Loopback" as the Type, enter an IP address, select an Edge Node for the interface, and then click "Save".

Note: More than one loopback may need to be configured depending on the routing architecture.

To set the source address for BGP neighbors do the following:

From the NSX-T Manager web interface, go to Networking >> Tier-0 Gateways >> expand the target Tier-0 gateway.

Expand BGP >> next to BGP Neighbors click on the number present to open the dialog >> select Edit on the target BGP Neighbor.

Under Source Addresses configure the source address with the loopback address and click Save.'
  impact 0.3
  tag check_id: 'C-55194r810153_chk'
  tag severity: 'low'
  tag gid: 'V-251757'
  tag rid: 'SV-251757r810155_rule'
  tag stig_id: 'T0RT-3X-000084'
  tag gtitle: 'SRG-NET-000512-RTR-000001'
  tag fix_id: 'F-55148r810154_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  t0s = http("https://#{input('nsxManager')}/policy/api/v1/infra/tier-0s",
              method: 'GET',
              headers: {
                'Accept' => 'application/json',
                'X-XSRF-TOKEN' => "#{input('sessionToken')}",
                'Cookie' => "#{input('sessionCookieId')}",
                },
              ssl_verify: false)

  describe t0s do
    its('status') { should cmp 200 }
  end
  unless t0s.status != 200
    t0sjson = JSON.parse(t0s.body)
    if t0sjson['results'] == []
      describe 'No T0 Gateways are deployed...skipping...' do
        skip 'No T0 Gateways are deployed...skipping...'
      end
    else
      t0sjson['results'].each do |t0|
        t0id = t0['id']
        # Get locale-services id for T0
        t0lss = http("https://#{input('nsxManager')}/policy/api/v1/infra/tier-0s/#{t0id}/locale-services",
                      method: 'GET',
                      headers: {
                        'Accept' => 'application/json',
                        'X-XSRF-TOKEN' => "#{input('sessionToken')}",
                        'Cookie' => "#{input('sessionCookieId')}",
                        },
                      ssl_verify: false)

        t0lssjson = JSON.parse(t0lss.body)
        next unless t0lssjson['result_count'] != 0
        t0lssjson['results'].each do |t0ls|
          t0lsid = t0ls['id']
          bgp = http("https://#{input('nsxManager')}/policy/api/v1/infra/tier-0s/#{t0id}/locale-services/#{t0lsid}/bgp",
                    method: 'GET',
                    headers: {
                      'Accept' => 'application/json',
                      'X-XSRF-TOKEN' => "#{input('sessionToken')}",
                      'Cookie' => "#{input('sessionCookieId')}",
                      },
                    ssl_verify: false)

          describe bgp do
            its('status') { should cmp 200 }
          end
          next unless bgp.status == 200
          bgpjson = JSON.parse(bgp.body)
          if bgpjson['enabled']
            describe "Detected T0: #{t0['display_name']} with BGP enabled...manually verify the source address for each neighbor is a loopback address for iBGP sessions" do
              skip "Detected T0: #{t0['display_name']} with BGP enabled...manually verify the source address for each neighbor is a loopback address for iBGP sessions"
            end
          else
            describe "BGP not enabled on T0: #{t0['display_name']}" do
              subject { bgpjson['enabled'] }
              it { should cmp 'false' }
            end
          end
        end
      end
    end
  end
end
