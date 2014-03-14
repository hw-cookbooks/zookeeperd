require "serverspec"
require "shared_examples_for_service"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = "/sbin:/usr/sbin"
  end
end
