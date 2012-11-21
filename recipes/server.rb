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

# TODO: This is one big race condition
unless(node[:zookeeperd][:zk_id])
  zk_search = 'zk_id:*'
  if(node[:zookeeperd][:common_environment])
    zk_search << " AND chef_environment:#{node.chef_environment}"
  end
  cur_id = search(:node, zk_search).map{|zk_node|
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
