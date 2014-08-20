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

describe Dirt::Context do
  describe '#run' do
    it 'should create an instance and call #call on it' do
      Dirt::Context.any_instance.should_receive(:call)

      Dirt::Context.run(double('params'))
    end

    it 'should pass forward params to #new' do
      args = double('params')

      Dirt::Context.should_receive(:new).with(args).and_call_original

      Dirt::Context.run(args)
    end
  end

  describe '#initialize' do
    it 'should accept no param' do
      Dirt::Context.new()
    end

    it 'should accept params' do
      args = double('params')

      Dirt::Context.new(args)
    end
  end
end