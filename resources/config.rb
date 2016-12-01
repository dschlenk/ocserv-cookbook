resource_name :ocserv_config
property :name, String, name_property: true, identity: true
property :value, String, required: true

load_current_value do
  if ::File.exist?(node['ocserv']['config'])
    pattern = /^#{name}\s*=\s*?(.*)$/
    lines = ::File.readlines(node['ocserv']['config']).grep(pattern)
    if lines.size > 0
      value lines[0].match(pattern).captures[0]
    else
    current_value_does_not_exist!
    end
  else
    current_value_does_not_exist!
  end
end

action :create do
  converge_if_changed do
    replace_or_add name do
      path node['ocserv']['config']
      pattern "^#{name} = "
      line "#{name} = #{value}"
    end
  end
end
