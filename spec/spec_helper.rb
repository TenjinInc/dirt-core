require 'bundler'
Bundler.require :test
FactoryGirl.find_definitions

require 'active_support/all'

RSpec.configure do |c|
  c.filter_run_excluding performance_test: true
end

shared_examples_for(:returning) do
  it "should return the appropriate messages" do
    actual_msgs = command[:messages]

    if msgs.nil? || msgs.empty?
      actual_msgs.should be_nil
    else
      actual_msgs.should_not be_nil

      msgs.each do |msg|
        actual_msgs.should include msg
      end
    end
  end

  it "should return the appropriate errors" do
    actual_errors = command[:errors]

    if errors.nil?
      actual_errors.should be_nil
    else
      errors.each do |error|
        actual_errors.should include error
      end
    end
  end
end

RSpec::Matchers.define :data_matches do |expected|
  match do |actual|
    expected == Hash[actual.instance_variables.map { |name| [name.to_s.gsub('@', '').to_sym, actual.instance_variable_get(name)] }]
  end
end