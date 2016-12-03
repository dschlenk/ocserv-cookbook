resource_name :ocserv_config
property :name, String, name_property: true, identity: true
property :value, String, required: true
default_action :create

action_class do
  include Ocserv::Config
end

load_current_value do
  extend Ocserv::Config
  val = config_value(name, node)
  value val unless val.nil?
  current_value_does_not_exist! if val.nil?
end

action :create do
  converge_if_changed do
    replace_or_add name do
      path node['ocserv']['config_file']
      pattern "^#{name} = "
      line "#{name} = #{value}"
      notifies :reload, 'service[ocserv]' unless (node['ocserv']['config']['ipv4-network'].nil? && node['ocserv']['config']['ipv6-network'].nil?)
    end
  end
end
