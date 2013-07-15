default[:zookeeperd][:server_packages] = %w(zookeeperd)
default[:zookeeperd][:client_packages] = %w(zookeeper)
default[:zookeeperd][:zk_id] = nil
default[:zookeeperd][:auto_id] = 'hostid'
default[:zookeeperd][:ipaddress] = node.ipaddress
default[:zookeeperd][:int_bit_limit] = 32
