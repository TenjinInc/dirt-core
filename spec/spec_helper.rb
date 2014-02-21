require 'bundler'
Bundler.require :test
FactoryGirl.find_definitions

require 'active_support/all'

RSpec.configure do |c|
  c.filter_run_excluding performance_test: true
end

RSpec::Matchers.define :data_matches do |expected|
  match do |actual|
    expected == Hash[actual.instance_variables.map { |name| [name.to_s.gsub('@', '').to_sym, actual.instance_variable_get(name)] }]
  end
end