default[:zookeeperd][:install][:platform_version] = node[:platform_version]
default[:zookeeperd][:install][:method] = 'package' # allowed: 'package' or 'jar'

default[:zookeeperd][:jar][:download][:version] = "3.4.6"
default[:zookeeperd][:jar][:download][:uri] = "http://archive.apache.org/dist/zookeeper"
default[:zookeeperd][:jar][:install_dir] = '/usr/local'
default[:zookeeperd][:jar][:base_dir] = '/usr/local/zookeeperd'
default[:zookeeperd][:jar][:log_dir] = '/var/log/zookeeper'
default[:zookeeperd][:jar][:pid_dir] = '/var/run/zookeeper'
default[:zookeeperd][:jar][:data_dir] = '/var/lib/zookeeper'

if(node.platform_family?('rhel', 'fedora', 'suse'))
  default[:zookeeperd][:server_packages] = %w(zookeeper-server)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper-server'
  default[:zookeeperd][:cloudera_repo] = true
  default[:zookeeperd][:cloudera][:baseurl] = "http://archive.cloudera.com/cdh4/redhat/#{node[:zookeeperd][:install][:platform_version].to_i}/#{node[:kernel][:machine]}/cdh/4/"
  default[:zookeeperd][:cloudera][:gpgkey] = "http://archive.cloudera.com/cdh4/redhat/#{node[:zookeeperd][:install][:platform_version].to_i}/#{node[:kernel][:machine]}/cdh/RPM-GPG-KEY-cloudera"
elsif(node.platform_family?('debian'))
  default[:zookeeperd][:server_packages] = %w(zookeeperd)
  default[:zookeeperd][:client_packages] = %w(zookeeper)
  default[:zookeeperd][:service_name] = 'zookeeper'
  default[:zookeeperd][:cloudera][:uri] = "http://archive.cloudera.com/cdh4/#{node[:platform]}/#{node[:lsb][:codename]}/amd64/cdh"
  default[:zookeeperd][:cloudera][:key] = "http://archive.cloudera.com/#{node[:platform_family]}/archive.key"
end

default[:zookeeperd][:cloudera][:init_dir_name] = "version-2"

# defaults to package default init unless set to runit
default[:zookeeperd][:init] = 'init'

default[:zookeeperd][:zk_id] = nil
default[:zookeeperd][:auto_id] = 'hostid'
default[:zookeeperd][:ipaddress] = node.ipaddress
default[:zookeeperd][:int_bit_limit] = 32

default[:zookeeperd][:user] = "zookeeper"
default[:zookeeperd][:group] = "zookeeper"

default[:zookeeperd][:open_file_limit] = 32768
default[:zookeeperd][:max_processes] = 1024

