cloudera = node[:zookeeperd][:cloudera_repo]

if cloudera
  include_recipe 'java'
  include_recipe 'zookeeperd::cloudera_repo'
end

log "zookeeperd pre-package hook"

include_recipe 'zookeeperd::client'

unless node[:zookeeperd][:zk_id]
  factor = node[:zookeeperd][:int_bit_limit]/8
  max_uint = 2**(%w(a).pack('p').size * factor) - 1
  if node[:zookeeperd][:auto_id].to_s != 'rand'
    node.set[:zookeeperd][:zk_id] = %x{hostid}.to_i(16)
  end
  if node[:zookeeperd][:zk_id].nil? || node[:zookeeperd][:zk_id] > max_uint
    node.set[:zookeeperd][:zk_id] = rand(max_uint)
  end
end

if node[:zookeeperd][:cluster][:auto_discovery]
  include_recipe 'zookeeperd::discovery'
end

Array(node[:zookeeperd][:server_packages]).each do |zkpkg|
  package zkpkg
end

execute 'zk_init' do
  command "/usr/bin/zookeeper-server-initialize"
  user node[:zookeeperd][:user]
  group node[:zookeeperd][:group]
  only_if do
    cloudera &&
      !::File.directory?(
        File.join(
          node[:zookeeperd][:config][:data_dir],
          node[:zookeeperd][:cloudera][:init_dir_name]
        )
      )
  end
end

template '/etc/zookeeper/conf/zoo.cfg' do
  source 'zoo.cfg.erb'
  mode 0644
  notifies :restart, 'service[zookeeper]'
end

unless(node[:zookeeperd][:zk_id])
  zk_nodes = discovery_all(
    'zk_id:*',
    :environment_aware => node[:zookeeperd][:cluster][:common_environment],
    :empty_ok => true,
    :minimum_response_time => false,
    :remove_self => false
  )
  cur_id = zk_nodes.map{|zk_node|
    zk_node[:zookeeperd][:zk_id].to_i
  }.max.to_i
  node.set[:zookeeperd][:zk_id] = cur_id + 1
  node.save
end

file '/etc/zookeeper/conf/myid' do
  content "#{node[:zookeeperd][:zk_id]}\n"
  mode 0644
  notifies :restart, 'service[zookeeper]'
end

template '/etc/zookeeper/conf/log4j.properties' do
  source 'log4j.properties.erb'
  mode 0644
  notifies :restart, 'service[zookeeper]'
end

if node[:zookeeperd][:service].to_s == 'runit'
  include_recipe 'zookeeperd::runit'
end

service 'zookeeper' do
  service_name node[:zookeeperd][:service_name]
  action [:enable, :start]
end

ruby_block 'mark as a zookeeper node' do
  block { node.set[:zookeeperd_server] = true }
end
