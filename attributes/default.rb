case node['platform_family']
when 'rhel'
  if node['platform_version'].to_f >= 7.0
    default['firewalld']['iptables_fallback'] = true
  end
  default['ocserv']['config'] = '/etc/ocserv/ocserv.conf'
end
