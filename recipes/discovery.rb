discover_query = [
  'zk_id:*',
  'zookeeperd_server:true'
]

discover_query += Array(node[:zookeeperd][:cluster][:discovery_query]).flatten.compact

# ensure that colons in search query values are escaped
# but leave first colon intact as query delimeter
discover_query = discover_query.map do |i|
  item = i.split(":", 2)
  key = item[0]
  value = item[1].gsub(":", '\:')
  [key, value].join(":")
end

zk_nodes = discovery_all(
  discover_query.join(' AND '),
  :environment_aware => node[:zookeeperd][:cluster][:common_environment],
  :empty_ok => true,
  :minimum_response_time_sec => false,
  :remove_self => true,
  :raw_search => true
)

zk_hash = {}
zk_discovery = {}
zk_nodes.push(node) unless node[:zookeeperd][:zk_id].to_s.strip.empty?


zk_nodes.each do |znode|
  zinfo = [znode[:zookeeperd][:ipaddress]]
  zinfo << znode[:zookeeperd][:cluster][:follower_port]
  zinfo << znode[:zookeeperd][:cluster][:election_port]
  zk_hash["server.#{znode[:zookeeperd][:zk_id]}"] = zinfo.join(':')
  zk_discovery["server.#{znode[:zookeeperd][:zk_id]}"] = znode[:zookeeperd][:ipaddress]
end

# ensure this node is in there (may not be on first run)
if(node[:zookeeperd][:zk_id])
  unless(zk_hash.has_key?("server.#{node[:zookeeperd][:zk_id]}"))
    zinfo = [node[:zookeeperd][:ipaddress]]
    zinfo << node[:zookeeperd][:cluster][:follower_port]
    zinfo << node[:zookeeperd][:cluster][:election_port]
    zk_hash["server.#{node[:zookeeperd][:zk_id]}"] = zinfo.join(':')
    zk_discovery["server.#{node[:zookeeperd][:zk_id]}"] = node[:zookeeperd][:ipaddress]
  end
end

node.set[:zookeeperd][:discovery] = zk_discovery

current_set = node[:zookeeperd][:config].map do |k,v|
  k if k.start_with?('server.')
end

zk_hash.each do |k,v|
  node.set[:zookeeperd][:config][k] = v
end

(current_set - zk_hash.keys).each do |stale_key|
  node.set[:zookeeperd][:config].delete(stale_key)
end
