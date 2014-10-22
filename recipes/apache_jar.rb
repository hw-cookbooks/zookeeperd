include_recipe "java"

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

template "/etc/security/limits.d/#{node["zookeeperd"]["user"]}.conf" do
  source "limits.conf.erb"
  owner node["zookeeperd"]["user"]
  group node["zookeeperd"]["group"]
  mode "0755"
  backup false
  notifies :restart, "service[zookeeper]", :delayed
end

if platform?("centos")
  package "rsync"
end

download_path = '/tmp'
download_filename = "zookeeper-#{node[:zookeeperd][:jar][:download][:version]}.tar.gz"
download_file_location = "#{download_path}/#{download_filename}"
download_remote = "#{node[:zookeeperd][:jar][:download][:uri]}/zookeeper-#{node[:zookeeperd][:jar][:download][:version]}/#{download_filename}"

remote_file download_file_location do
  action :create_if_missing
  source download_remote
  group node["zookeeperd"]["group"]
  owner node["zookeeperd"]["user"]
  mode 00644
  backup false
end

execute "Unpack zookeeper from download" do
  cwd download_path
  command "tar -xzf #{download_filename}"
  not_if { ::File.exists?("#{download_path}/zookeeper-#{node[:zookeeperd][:jar][:download][:version]}") }
end

execute "Install zookeeper files" do
  cwd download_path
  command "rsync -az zookeeper-#{node[:zookeeperd][:jar][:download][:version]} #{node[:zookeeperd][:jar][:install_dir]}/"
  not_if { ::File.exists?("#{node[:zookeeperd][:jar][:install_dir]}/zookeeper-#{node[:zookeeperd][:jar][:download][:version]}") }
end

link node[:zookeeperd][:jar][:base_dir] do
 to "#{node[:zookeeperd][:jar][:install_dir]}/zookeeper-#{node[:zookeeperd][:jar][:download][:version]}"
end

directory node[:zookeeperd][:jar][:log_dir] do
  owner node[:zookeeperd][:user]
  group node[:zookeeperd][:group]
end

directory node[:zookeeperd][:jar][:pid_dir] do
  owner node[:zookeeperd][:user]
  group node[:zookeeperd][:group]
end

directory "#{node[:zookeeperd][:jar][:data_dir]}/version-2" do
  owner node[:zookeeperd][:user]
  group node[:zookeeperd][:group]
  recursive true
end

template "/usr/bin/zookeeper-server" do
  source "zookeeper-server.erb"
  mode 00755
end

template "#{node[:zookeeperd][:jar][:base_dir]}/bin/zkServer-initialize.sh" do
  source "zkServer-initialize.sh.erb"
  mode 00755
end

if node.platform_family?('rhel', 'fedora', 'suse')
  init_file = '/etc/init.d/zookeeper-server'
elsif node.platform_family?('debian')
  init_file = '/etc/init.d/zookeeper'
end

template init_file do
  source  "init.erb"
  group node["zookeeperd"]["group"]
  owner node["zookeeperd"]["user"]
  mode 00755
  backup false
end
