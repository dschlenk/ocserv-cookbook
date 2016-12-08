name             'ocserv'
maintainer       'ConvergeOne Holding Corp.'
maintainer_email 'C1C_rnd@convergeone.com'
license          'Apache v2.0'
description      'Installs/Configures OpenConnect VPN Server'
long_description 'Installs/Configures OpenConnect VPN Server on CentOS 6.x/7.x'
version          '0.1.1'
issues_url       'https://bitbucket.org/c1c_rnd/ocserv-cookbook/issues'
source_url       'https://bitbucket.org/c1c_rnd/ocserv-cookbook/src'
depends          'firewalld'
depends          'yum-epel'
depends          'simple_iptables'
supports         'rhel', '>= 6.8'
attribute 'ocserv/config/ipv4-network',
  display_name: 'ipv4-network',
  description: 'The pool of addresses that leases will be given from.\
If the leases are given via Radius, or via the explicit-ip? per-user config \
option then these network values should contain a network with at least a \
single address that will remain under the full control of ocserv (that is \
to be able to assign the local part of the tun device address). \
CIDR notation. Either this attribute or ipv6-network is required.',
  type: 'string',
  required: 'optional'
#  :recipes => \[ 'ocserv::default', 'ocserv::install_ocserv' \]
attribute 'ocserv/config/ipv6-network',
  display_name: 'ipv6-network',
  description: 'The pool of addresses that leases will be given from.\
If the leases are given via Radius, or via the explicit-ip? per-user config \
option then these network values should contain a network with at least a \
single address that will remain under the full control of ocserv (that is \
to be able to assign the local part of the tun device address). \
IPv6 CIDR notation. Either this attribute or ipv4-network is required. ',
  type: 'string',
  required: 'optional'
#  :recipes => \[ 'ocserv::default', 'ocserv::install_ocserv' \]
