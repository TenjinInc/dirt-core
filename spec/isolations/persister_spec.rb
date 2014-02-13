require "rspec"
require './lib/roles/role'
require './lib/persisters/persister'

describe Persister do
  describe '#for' do
    class FooBar
    end

    module HerpZerp
      module DerpGerp
        class FooBar

        end
      end
    end

    [FooBar, HerpZerp::DerpGerp::FooBar, :foo_bar].each do |arg|
      context "#{arg} is passed in" do
        let(:expected_persister) { double('Peristathingy') }

        it 'should save using the given argument and return the expected persister with the appropriate symbol' do
          Persister.for(arg, expected_persister)
          Persister.for(:foo_bar).should be expected_persister
        end

        after(:each) { Persister.clear }
      end
    end
  end

  describe '#clear' do
    it 'should empty the persisters hash' do
      Persister.clear

      Persister.class_variable_get(:@@persisters).should == nil
    end
  end
end