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
  describe Role do
    let(:decorated) { double('decorated', test_method: nil) }

    subject do
      Role.new(decorated)
    end

    describe '#method_missing' do
      context 'the method is supported' do
        before(:each) { decorated.stub(:respond_to?).and_return(true) }

        it 'should call the method on the decorated object' do
          decorated.should_receive(:test_method).with([], nil)

          subject.method_missing(:test_method, [], nil)
        end
      end

      context 'the method is not supported' do
        before(:each) { decorated.stub(:respond_to?).and_return(false) }

        it 'should call the method on the decorated object' do
          decorated.should_receive(:test_method)

          subject.method_missing(:test_method, [], nil)
        end
      end
    end

    describe '#respond_to?' do
      context 'the method is supported directly' do
        before(:each) { subject.stub(:test_method) }

        it 'should return true' do
          decorated.should_not_receive(:respond_to?)

          subject.respond_to?(:test_method).should == true
        end
      end

      context 'the method is not supported directly' do
        it 'should ask the decorated object' do
          decorated.should_receive(:respond_to?).with(:test_method, false).and_return(true)

          subject.respond_to?(:test_method).should == true
        end
      end

      context 'the method is not supported at all' do
        it 'should ask the decorated object' do
          decorated.should_receive(:respond_to?).with(:another_method, false).and_return(false)

          subject.respond_to?(:another_method).should == false
        end
      end
    end

    describe '#== ' do
      it 'should be equal with identical contents' do
        subject.should == Persisting.new(decorated)
      end

      it 'should equal itself' do
        subject.should == subject
      end

      it 'should equal the decorated object' do
        subject.should == decorated
      end

      it 'should not equal a different object' do
        subject.should_not == double('something else entirely')
      end

      context 'equivalent contents' do
        let(:decorated) { [5] }

        it 'should be equal with equivalent contents' do
          clone = [5]
          decorated.should == clone
          subject.should == Persisting.new(clone)
        end
      end

      it 'should not equal others with different contents' do
        subject.should_not == Persisting.new(double('something else entirely'))
      end
    end
  end
end