require "serverspec"
require "shared_examples_for_service"

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = "/sbin:/usr/sbin"
  end
  output_dir = '/tmp/output'
  Dir.mkdir(output_dir) unless Dir.exist?(output_dir)
  c.output_stream = File.open(File.join(output_dir,'serverspec.json'), 'w')
  c.formatter = 'json'
end
