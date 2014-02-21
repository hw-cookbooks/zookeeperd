require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe "Zookeeper" do

  it "is listening on a custom port" do
    expect(port(9000)).to be_listening
  end

  it "has a running service of zookeeper" do
    expect(service("zookeeper")).to be_running
  end
end
