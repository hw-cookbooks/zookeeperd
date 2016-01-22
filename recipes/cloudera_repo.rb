yum_repository 'cloudera-cdh5' do
  description "Cloudera's Distribution for Hadoop, Version 5"
  baseurl node['zookeeperd']['cloudera']['baseurl']
  gpgkey node['zookeeperd']['cloudera']['gpgkey']
  action :create
  only_if { node.platform_family?('rhel', 'fedora', 'suse') }
end

apt_repository 'cloudera' do
  uri node['zookeeperd']['cloudera']['uri']
  arch 'amd64'
  distribution "#{node['lsb']['codename']}-cdh5"
  components ['contrib']
  key node['zookeeperd']['cloudera']['key']
  only_if { node.platform_family?('debian') }
end

apt_preference 'cloudera' do
  glob '*'
  pin 'origin archive.cloudera.com'
  pin_priority '700'
  only_if { node.platform_family?('debian') }
end
