module Ocserv
  module Config
    def config_value(key, node)
      if ::File.exist?(node['ocserv']['config_file'])
        pattern = /^#{key}\s*=\s*?(.*)$/
        lines = ::File.readlines(node['ocserv']['config_file']).grep(pattern)
        lines[0].match(pattern).captures[0] unless lines.empty?
      end
    end
  end
end
