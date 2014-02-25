if(node[:zookeeperd][:cloudera_repo] == true)
  include_recipe 'java'
  include_recipe 'zookeeperd::cloudera_repo'
end

node[:zookeeperd][:client_packages].each do |zkpkg|
  package zkpkg
end
