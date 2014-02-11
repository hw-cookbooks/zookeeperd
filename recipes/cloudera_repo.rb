yum_repository 'cloudera-cdh4' do
  description "Cloudera's Distribution for Hadoop, Version 4"
  baseurl "http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/4/"
  gpgkey 'http://archive.cloudera.com/cdh4/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera'
  action :create
  only_if { node.platform_family?('rhel', 'fedora', 'suse') }
end
