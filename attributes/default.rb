case node['platform']
when 'redhat', 'centos', 'scientific', 'fedora', 'suse', 'amazon', 'oracle'
  default[:zookeeperd][:server_packages] = %w(zookeeper-server)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper-server'
when 'debian', 'ubuntu'
  default[:zookeeperd][:server_packages] = %w(zookeeperd)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper'
end

default[:zookeeperd][:zk_id] = nil
default[:zookeeperd][:auto_id] = 'hostid'
default[:zookeeperd][:ipaddress] = node.ipaddress
default[:zookeeperd][:int_bit_limit] = 32

#default[:java][:install_flavor] = "openjdk"
#default[:java][:jdk_version] = "6"
