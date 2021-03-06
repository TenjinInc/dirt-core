#--
# Copyright (c) 2014 Tenjin Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require './spec/isolations/spec_helper'

module Dirt
  describe Persister do
    let(:fake_persister) { double 'Fake Persister' }

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
          expect { Persister.for(:bogus_type) }.to raise_error(NoPersisterError, 'There is no persister for "bogus_types".')
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

        expect { Persister.transaction([fake_persister]) do
          raise StandardError, "Different Error"
        end }.to raise_error(StandardError, "Different Error")
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

        Persister.transaction([p1, p2, p3]) do
          "Trigger Block"
        end.should == ">>>Trigger Block<<<"
      end
    end
  end
end