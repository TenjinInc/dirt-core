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

describe SelfExistenceValidator do
  let(:id) { double('id') }
  let(:persister) { double('persister') }
  let(:decorated) { double('decorated') }

  subject { SelfExistenceValidator.new(RSpec::Mocks::TestDouble, id) }

  before(:each) do
    Persister.for(RSpec::Mocks::TestDouble, persister)
  end

  after(:each) do
    Persister.clear
  end

  describe '#valid?' do
    context 'decorated object exists in the persister' do
      before(:each) do
        persister.stub(:exists?).and_return(true)
      end

      it 'should return true' do
        subject.valid?(decorated).should be true
      end
    end

    context 'decorated object does not exist in persister' do
      before(:each) do
        persister.stub(:exists?).and_return(false)
      end

      it 'should return false' do
        decorated.stub(:test_property).and_return('')

        subject.valid?(decorated).should be false
      end
    end
  end
end