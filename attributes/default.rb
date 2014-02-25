if(node.platform_family?('rhel', 'fedora', 'suse'))
  default[:zookeeperd][:server_packages] = %w(zookeeper-server)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper-server'
  default[:zookeeperd][:cloudera_repo] = true
  default[:zookeeperd][:cloudera][:baseurl] = "http://archive.cloudera.com/cdh4/#{node[:languages][:ruby][:target_vendor]}/#{node[:platform_version].to_f.floor}/#{node[:kernel][:machine]}/cdh/4/"
  default[:zookeeperd][:cloudera][:gpgkey] = "http://archive.cloudera.com/cdh4/#{node[:languages][:ruby][:target_vendor]}/#{node[:platform_version].to_f.floor}/#{node[:kernel][:machine]}/cdh/RPM-GPG-KEY-cloudera"
elsif(node.platform_family?('debian'))
  default[:zookeeperd][:server_packages] = %w(zookeeperd)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper'
  default[:zookeeperd][:cloudera][:uri] = "http://archive.cloudera.com/cdh4/#{node[:platform]}/#{node[:lsb][:codename]}/amd64/cdh"
  default[:zookeeperd][:cloudera][:key] = "http://archive.cloudera.com/#{node[:platform_family]}/archive.key" 
end

default[:zookeeperd][:zk_id] = nil
default[:zookeeperd][:auto_id] = 'hostid'
default[:zookeeperd][:ipaddress] = node.ipaddress
default[:zookeeperd][:int_bit_limit] = 32

