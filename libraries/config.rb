module Ocserv
  module Config
    def config_value(key, node)
      values = []
      if ::File.exist?(node['ocserv']['config_file'])
        pattern = /^#{key}\s*=\s*(.*)$/
        lines = ::File.readlines(node['ocserv']['config_file']).grep(pattern)
        unless lines.empty?
          lines.each do |line|
            values.push(line.match(pattern).captures[0])
          end
        end
      end
      return values[0] if !values.empty? && values.size == 1
      values
    end

    def replace_or_add_config(name, value, node)
      newlines = []
      ::File.readlines(node['ocserv']['config_file']).each do |line|
        newlines.push(line) unless line =~ /^#{name} = .*$/
      end
      ::File.open(node['ocserv']['config_file'], 'w') do |f|
        # unchanged lines
        newlines.each do |l|
          f.write(l)
        end
        # new or replaced lines
        nrvals = value
        nrvals = [value] unless value.is_a? Array
        nrvals.each do |nrv|
          f.write("#{name} = #{nrv}\n")
        end
      end
    end
  end
end
