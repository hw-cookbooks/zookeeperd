include_recipe 'zookeeperd::client'

if(node[:zookeeperd][:cluster][:auto_discovery])
  include_recipe 'zookeeperd::discovery'
end

node[:zookeeperd][:server_packages].each do |zkpkg|
  package zkpkg
end

template '/etc/zookeeper/conf/zoo.cfg' do
  source 'zoo.cfg.erb'
  mode 0644
  notifies :restart, 'service[zookeeper]'
end

node.default[:zookeeperd][:zk_id] = %x{hostid}.to_16

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

service 'zookeeper' do
  action :start
end
