zk_search = 'zk_id:*'
if(node[:zookeeperd][:cluster][:common_environment])
  zk_search << " AND chef_environment:#{node.chef_environment}"
end
zk_nodes = search(:node, zk_search)

zk_nodes.each do |znode|
  node[:zookeeperd][:config]["server.#{znode[:zookeeperd][:zk_id]}"] = "#{znode[:ipaddress]}:#{znode[:zookeeperd][:cluster][:follower_port]}:#{znode[:zookeeperd][:cluster][:election_port]}"
end
