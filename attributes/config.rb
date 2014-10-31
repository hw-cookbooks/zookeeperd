default[:zookeeperd][:config][:client_port] = 2181
default[:zookeeperd][:config][:tick_time] = 2000
default[:zookeeperd][:config][:init_limit] = 10
default[:zookeeperd][:config][:sync_limit] = 5
default[:zookeeperd][:config][:data_dir] = '/var/lib/zookeeper'
default[:zookeeperd][:config][:server] = []
default[:zookeeperd][:config][:pre_alloc_size] = 65536
default[:zookeeperd][:config][:snap_count] = 10000
default[:zookeeperd][:config][:leader_serves] = true

default[:zookeeperd][:discovery] = {}
