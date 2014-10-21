include_recipe "java"

# Create zookeeper user/group
group node["zookeeperd"]["group"] do
  action :create
end

user node["zookeeperd"]["user"] do
  comment "Zookeeper user"
  gid node["zookeeperd"]["group"]
  shell "/bin/bash"
  home "/home/#{node["zookeeperd"]["user"]}"
  supports :manage_home => true
end

# Create limits.d conf to set zookeeper open file limit and max processes
template "/etc/security/limits.d/#{node["zookeeperd"]["user"]}.conf" do
  source "limits.conf.erb"
  owner node["zookeeperd"]["user"]
  group node["zookeeperd"]["group"]
  mode "0755"
  backup false
  notifies :restart, "service[zookeeperd]", :delayed
end

# Configure zookeeper user's bash profile
template "/home/#{node["zookeeperd"]["user"]}/.bash_profile" do
  source  "bash_profile.erb"
  owner node["zookeeperd"]["user"]
  group node["zookeeperd"]["group"]
  mode  00755
  notifies :restart, "service[zookeeperd]", :delayed
end

download_path = '/tmp'
download_filename = "zookeeper-#{node[:zookeeperd][:jar][:version]}.tar.gz"
download_file_location = "#{download_path}/#{download_filename}"
download_remote = "#{node[:zookeeperd][:jar][:download][:uri]}/#{download_filename}"

# Download binary zip file
remote_file download_file_location do
  action :create_if_missing
  source download_remote
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00644
  backup false
end

# Setup zookeeper's init script
template "/etc/init.d/zookeeper" do
  source  "init.erb"
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  backup false
end

# Start zookeeper service
service "zookeeper" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
