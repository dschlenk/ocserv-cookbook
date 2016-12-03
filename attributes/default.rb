case node['platform_family']
when 'rhel'
  if node['platform_version'].to_f >= 7.0
    default['firewalld']['iptables_fallback'] = true
    default['ocserv']['version'] = '0.11.5-1.el7' # until RH Bug #1400693
  end
  default['ocserv']['config_file'] = '/etc/ocserv/ocserv.conf'
end
default['ocserv']['config']['tcp-port'] = 443
default['ocserv']['config']['udp-port'] = 443
