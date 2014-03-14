def enable_runit_service(name)
  ChefSpec::Matchers::ResourceMatcher.new(:runit_service, :enable, name)
end
