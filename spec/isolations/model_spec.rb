require 'spec_helper'
require 'models/model'

describe Model do
  # Need to give it a attributes for testing
  class Model
    attr_accessor :test_variable1, :test_variable2
  end

  let(:expected_value1) { double('a variable') }
  let(:expected_value2) { double('something else') }

  subject { Model.new(test_variable1: expected_value1, test_variable2: expected_value2) }

  context '#initialize' do
    it 'should save the given params from the hash' do
      subject.test_variable1.should == expected_value1
      subject.test_variable2.should == expected_value2
    end
  end

  context '#update' do
    subject { Model.new() }

    it 'should save the given params from the hash' do
      subject.update(test_variable1: expected_value1, test_variable2: expected_value2)

      subject.test_variable1.should == expected_value1
      subject.test_variable2.should == expected_value2
    end
  end

  context '#to_hash' do
    it 'should return the model data as a hash' do
      subject.to_hash.should == {test_variable1: expected_value1, test_variable2: expected_value2}
    end
  end

  context '#==' do
    it 'should return false vs nil' do
      subject.==(nil).should be false
    end

    it 'should return false vs a different object' do
      subject.==(double('different thingy')).should be false
    end

    it 'should return true vs itself' do
      subject.==(subject).should be true
    end

    it 'should return true vs another object with equivalent values' do
      other = double('different thingy')

      other.stub(:instance_variable_get).and_return do |*args|
        if args.first == :@test_variable1
          expected_value1
        elsif   args.first == :@test_variable2
          expected_value2
        end
      end

      subject.==(other).should be true
    end
  end
end