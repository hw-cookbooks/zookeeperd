zk_nodes = discovery_all(
  'zk_id:*', 
  :environment_aware => node[:zookeeperd][:cluster][:common_environment],
  :empty_ok => true,
  :minimum_response_time_sec => false,
  :remove_self => false,
  :raw_search => true
)

zk_hash = {}

zk_nodes.each do |znode|
  zk_hash["server.#{znode[:zookeeperd][:zk_id]}"] = "#{znode[:ipaddress]}:#{znode[:zookeeperd][:cluster][:follower_port]}:#{znode[:zookeeperd][:cluster][:election_port]}"
end

# ensure this node is in there (may not be on first run)

unless(zk_hash.has_key?("server.#{node[:zookeeperd][:zk_id]}"))
  zk_hash["server.#{node[:zookeeperd][:zk_id]}"] = "#{node[:ipaddress]}:#{node[:zookeeperd][:cluster][:follower_port]}:#{node[:zookeeperd][:cluster][:election_port]}"
end
node.set[:zookeeperd][:config] = zk_hash
