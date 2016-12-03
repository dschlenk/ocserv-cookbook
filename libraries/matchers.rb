if defined?(ChefSpec)
  def create_ocserv_config(name)
    ChefSpec::Matchers::ResourceMatcher.new(:ocserv_config, :create, name)
  end
end
