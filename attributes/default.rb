if(node.platform_family?('rhel', 'fedora', 'suse'))
  default[:zookeeperd][:server_packages] = %w(zookeeper-server)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper-server'
  default[:zookeeperd][:cloudera_repo] = true
elsif(node.platform_family?('debian'))
  default[:zookeeperd][:server_packages] = %w(zookeeperd)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper'
end

default[:zookeeperd][:zk_id] = nil
default[:zookeeperd][:auto_id] = 'hostid'
default[:zookeeperd][:ipaddress] = node.ipaddress
default[:zookeeperd][:int_bit_limit] = 32

default[:zookeeperd][:cloudera][:baseurl] = "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/"
default[:zookeeperd][:cloudera][:gpgkey] = "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera"
default[:zookeeperd][:cloudera][:uri] = "http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh"
default[:zookeeperd][:cloudera][:key] = "http://archive.cloudera.com/debian/archive.key"
