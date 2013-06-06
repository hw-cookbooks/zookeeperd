zk_nodes = discovery_all(
  'zk_id:* AND recipes:zookeeperd\:\:server', 
  :environment_aware => node[:zookeeperd][:cluster][:common_environment],
  :empty_ok => true,
  :minimum_response_time_sec => false,
  :remove_self => true,
  :raw_search => true
)

zk_hash = {}
zk_nodes.push(node) if node[:zookeeperd][:zk_id]

zk_nodes.each do |znode|
  zinfo = [znode[:zookeeperd][:ipaddress]]
  zinfo << znode[:zookeeperd][:cluster][:follower_port]
  zinfo << znode[:zookeeperd][:cluster][:election_port]
  zk_hash["server.#{znode[:zookeeperd][:zk_id]}"] = zinfo.join(':')
end

# ensure this node is in there (may not be on first run)
if(node[:zookeeperd][:zk_id])
  unless(zk_hash.has_key?("server.#{node[:zookeeperd][:zk_id]}"))
    zinfo = [node[:zookeeperd][:ipaddress]]
    zinfo << node[:zookeeperd][:cluster][:follower_port]
    zinfo << node[:zookeeperd][:cluster][:election_port]
    zk_hash["server.#{node[:zookeeperd][:zk_id]}"] = zinfo.join(':')
  end
end

zk_hash.each do |k,v|
  node.set[:zookeeperd][:config][k] = v
end
