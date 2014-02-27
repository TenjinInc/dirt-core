require "rspec"
require './lib/roles/role'
require './lib/persisters/persister'
require './lib/errors/transaction_error'

describe Persister do
  let(:fake_persister){double 'Fake Persister'}

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

    context 'no persister for type' do
      it 'should throw an exception' do
        expect { Persister.for(:bogus_type)}.to raise_error(NoPersisterError, 'There is no persister for "bogus_types".')
      end
    end
  end

  describe '#clear' do
    it 'should empty the persisters hash' do
      Persister.clear

      Persister.class_variable_get(:@@persisters).should == nil
    end
  end

  describe "#transaction" do
    it "should return errors when a Transaction error is raised" do
      Persister.stub(:for).and_return(fake_persister)
      expect(fake_persister).to receive(:transaction) do |&block|
        block.call
      end

      Persister.transaction([fake_persister]) do
        raise TransactionError, "The Error"
      end.should == {errors: ["The Error"]}
    end

    it "should not rescue non-transaction errors" do
      Persister.stub(:for).and_return(fake_persister)
      expect(fake_persister).to receive(:transaction) do |&block|
        block.call
      end

      expect {Persister.transaction([fake_persister]) do
        raise StandardError, "Different Error"
      end}.to raise_error(StandardError, "Different Error")
    end

    it "should trigger the block within the transactions of all persisters" do
      p1, p2, p3 = double('persister'), double('persister'), double('persister')
      p1.stub(:transaction) do |&block|
        ">#{block.call}<"
      end

      p2.stub(:transaction) do |&block|
        ">#{block.call}<"
      end

      p3.stub(:transaction) do |&block|
        ">#{block.call}<"
      end

      Persister.transaction([p1,p2,p3]) do
        "Trigger Block"
      end.should == ">>>Trigger Block<<<"
    end
  end
end