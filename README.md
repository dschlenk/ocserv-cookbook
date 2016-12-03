# ocserv Cookbook

Installs and configures ocserv, the [OpenConnect server](http://www.infradead.org/ocserv/manual.html).

## Requirements

### Platforms

CentOS 6.8+, 7.2+ x86_64.

### Chef

Chef 12+, preferably 12.5.1+ but older with `compat-resources` should work.

### Cookbooks

Depends on the following cookbooks
  * firewalld (the `disable` recipe is run on CentOS 7)
  * line
  * simple_iptables

### Attributes
- One of the following attributes must be populated or the service will not start:
  * `node['ocserv']['config']['ipv4-network']`: The pool of addresses that leases will be given from. If the leases are given via Radius, or via the explicit-ip? per-user config option then these network values should contain a network with at least a single address that will remain under the full control of ocserv (that is to be able to assign the local part of the tun device address). CIDR notation. 
  * `node['ocserv']['config']['ipv6-network']`: The pool of addresses that leases will be given from. If the leases are given via Radius, or via the explicit-ip? per-user config option then these network values should contain a network with at least a single address that will remain under the full control of ocserv (that is to be able to assign the local part of the tun device address). IPv6 CIDR notation.


## Attributes

### ocserv::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ocserv']['config']['ipv4-network']</tt></td>
    <td>String</td>
    <td>The pool of addresses that leases will be given from. If the leases are given via Radius, or via the explicit-ip? per-user config option then these network values should contain a network with at least a single address that will remain under the full control of ocserv (that is to be able to assign the local part of the tun device address). CIDR notation.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['ocserv']['config']['ipv6-network']</tt></td>
    <td>String</td>
    <td>IPv6 version of the above.</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['ocserv']['config']['tcp_port']</tt></td>
    <td>Integer</td>
    <td>The TCP port that ocserv will use for TLS.</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['ocserv']['config']['udp_port']</tt></td>
    <td>Integer</td>
    <td>The UDP port that ocserv will use for DTLS.</td>
    <td><tt>443</tt></td>
  </tr>
  <tr>
    <td><tt>['ocserv']['config'][...]</tt></td>
    <td>Object</td>
    <td>Additional configuration key/value pairs can be set as attributes under `node['ocserv']['config']` to change their defaults in the main configuration file.</td>
    <td><tt>NA</tt></td>
  </tr>
</table>

## Recipes

### ocserv::default

This recipe installs the `epel-release` package and `ocserv` package from EPEL. If either or both of `node['ocserv']['ipv4-network']` or `node['ocserv']['ipv6-network']` are set, the ocserv service will be enabled and started. On CentOS 7.x firewalld is replaced with iptables. Any configuration key/values added to `node['ocserv']['config']` will be set in the ocserv configuration file and iptables rules are created to allow traffic to the ports specified in `node['ocserv']['config']['tcp_port']` and `node['ocserv']['config']['udp_port']` (both default to 443). 

### ocserv::install_ocserv

If you'd prefer a less comprehensive solution this recipe will only install `epel-release` and `ocserv` and enable/start the service when a network is defined. 


## Custom Resources

The custom resource `ocserv_config` is available for use to change a configuration item without setting node attributes. It is also used internally by the default recipe to apply configuration values specified in `node['ocserv']['config']`.  See the ocserv manual for all options. This resource does not ensure that the keys or values you provide make any sense, but it will accurately replace existing values.  An example:

```
ocserv_config 'dpd' do
  value '180'
end
```

would change the `dpd` configuration from the default (90) to 180.

The `value` property must be a string and is required. 

Reading through the manual you will notice that some things are wrapped in double quotes. You'd be wise to follow suit, such as:

```
ocserv_config 'auth' do
  value '"plain[passwd=./sample.passwd,otp=./sample.otp]"'
end
```

## Contributing

1. Fork the repository on BitBucket
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable). Both ChefSpec and Serverspec tests exist.
5. Run the tests, ensuring they all pass
6. Submit a Pull Request.

## License and Authors

Authors: 

- David Schlenk <dschlenk@convergeone.com>

License: Apache 2.0
