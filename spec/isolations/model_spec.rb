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
  describe ModelBehaviour do
    # Need to give it a attributes for testing
    class Model
      include ModelBehaviour
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

        subject.==(other).should == true
      end
    end
  end
end