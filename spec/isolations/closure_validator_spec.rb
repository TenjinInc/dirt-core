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

describe ClosureValidator do
  let(:expected_validity) { double('validity') }
  let(:expected_error) { double('error') }

  describe 'closure use' do
    subject do
      ClosureValidator.new(lambda { |val| expected_validity }, lambda { |err| expected_error })
    end

    it 'should use the block to determines validity' do
      subject.valid?(expected_validity).should be expected_validity
    end

    it 'should use the second block to determine the error' do
      subject.error_message(expected_error).should be expected_error
    end
  end

  describe 'parameters' do
    subject do
      ClosureValidator.new(lambda { |val| val }, lambda { |err| err })
    end

    it 'should pass the validated object into the valid? closure' do
      subject.valid?(expected_validity).should be expected_validity
    end

    it 'should pass the validated object into the error closure' do
      subject.error_message(expected_error).should be expected_error
    end
  end
end