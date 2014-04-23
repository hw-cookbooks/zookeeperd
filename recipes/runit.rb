cloudera = node[:zookeeperd][:cloudera_repo]
service_name = node[:zookeeperd][:service_name]
runit_template = cloudera ? "cloudera-zookeeper" : "zookeeper"

if platform_family?("debian") && cloudera
  pkg_opts = [
    %{-o Dpkg::Options::="--force-confdef"},
    %{-o Dpkg::Options::="--force-confold"}
  ].join(" ")

  Array(node[:zookeeperd][:server_packages]).each do |pkg|
    resources("package[#{pkg}]").options(pkg_opts)
  end

  file "/etc/init.d/#{service_name}" do
    content "#!/bin/sh\n# Disabled by Chef\n\nexit 0"
    mode 0755
    subscribes :create, "log[zookeeperd pre-package hook]", :immediately
    action :nothing
  end
elsif platform_family?("debian")
  dpkg_autostart service_name do
    allow false
    subscribes :create, "log[zookeeperd pre-package hook]", :immediately
    action :nothing
  end
end

directory "/var/run/zookeeper" do
  owner node[:zookeeperd][:user]
end

include_recipe "runit"

runit_service service_name do
  template_name runit_template
  default_logger true
  action :enable
end
