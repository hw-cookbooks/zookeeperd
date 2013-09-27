discover_query = [
  'zk_id:*',
  'zookeeperd_server:true'
]

discover_query += Array(node[:zookeeperd][:cluster][:discovery_query]).flatten.compact

zk_nodes = discovery_all(
  discover_query.join(' AND '),
  :environment_aware => node[:zookeeperd][:cluster][:common_environment],
  :empty_ok => true,
  :minimum_response_time_sec => false,
  :remove_self => true,
  :raw_search => true
)

zk_hash = {}
zk_nodes.push(node) unless node[:zookeeperd][:zk_id].to_s.strip.empty?

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

current_set = node[:zookeeperd][:config].map do |k,v|
  k if k.start_with?('server.')
end

zk_hash.each do |k,v|
  node.set[:zookeeperd][:config][k] = v
end

(current_set - zk_hash.keys).each do |stale_key|
  node.set[:zookeeperd][:config].delete(stale_key)
end
