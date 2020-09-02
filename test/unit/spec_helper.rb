require 'chefspec'
require 'chefspec/librarian'
require_relative 'support/matchers'

RSpec.configure do |config|
  config.log_level = :fatal
end
