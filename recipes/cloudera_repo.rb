yum_repository 'cloudera-cdh4' do
  description   "Cloudera's Distribution for Hadoop, Version 4"
  baseurl       node[:zookeeperd][:cloudera][:baseurl]
  gpgkey        node[:zookeeperd][:cloudera][:gpgkey]
  action        :create
  only_if { node.platform_family?('rhel', 'fedora', 'suse') }
end

apt_repository 'cloudera' do
  uri          node[:zookeeperd][:cloudera][:uri]
  arch         'amd64'
  distribution 'precise-cdh4'
  components   ['contrib']
  key          node[:zookeeperd][:cloudera][:key]
  only_if { node.platform_family?('debian') }
end

node.default[:zookeeperd][:client_packages] = %w(zookeeper)
node.default[:zookeeperd][:server_packages] = %w(zookeeper-server)
node.default[:zookeeperd][:service_name] = "zookeeper-server"
