yum_repository 'cloudera-cdh4' do
  description   "Cloudera's Distribution for Hadoop, Version 4"
  baseurl       "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/"
  gpgkey        'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera'
  action        :create
  only_if { node.platform_family?('rhel', 'fedora', 'suse') }
end

apt_repository 'cloudera' do
  uri          'http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh'
  arch         'amd64'
  distribution 'precise-cdh4'
  components   ['contrib']
  key          'http://archive.cloudera.com/debian/archive.key'
  only_if { node.platform_family?('debian') }
end

node.default[:zookeeperd][:client_packages] = %w(zookeeper)
node.default[:zookeeperd][:server_packages] = %w(zookeeper-server)
node.default[:zookeeperd][:service_name] = "zookeeper-server"
