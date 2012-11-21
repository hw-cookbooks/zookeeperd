node[:zookeeperd][:client_packages].each do |zkpkg|
  package zkpkg
end
