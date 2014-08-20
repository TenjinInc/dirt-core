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

describe Validating do
  let(:validator1) { double('validator') }
  let(:validator2) { double('validator2') }
  let(:decorated) { double('decorated') }

  subject { Validating.new(decorated, [validator1, validator2]) }

  describe '#valid?' do
    context 'all validators pass' do
      it 'should return true' do
        validator1.stub(:valid?).and_return(true)
        validator2.stub(:valid?).and_return(true)

        subject.valid?.should be true
      end
    end

    context 'one of the validators fails' do
      it 'should return false' do
        validator1.stub(:valid?).and_return(true)
        validator2.stub(:valid?).and_return(false)

        subject.valid?.should be false
      end
    end
  end

  describe '#errors' do
    context 'all validators pass' do
      it 'should return true' do
        validator1.stub(:valid?).and_return(true)
        validator2.stub(:valid?).and_return(true)

        subject.errors.should == []
      end
    end

    context 'one of the validators fails' do
      it 'should return false' do
        msg = double('a msg')
        validator1.stub(:valid?).and_return(true)
        validator2.stub(:valid?).and_return(false)
        validator2.stub(:error_message).and_return(msg)

        subject.errors.should == [msg]
      end
    end

    context 'multiple validators fail' do
      it 'should return false' do
        msg = double('a msg')
        msg2 = double('another msg')

        validator1.stub(:valid?).and_return(false)
        validator2.stub(:valid?).and_return(false)
        validator1.stub(:error_message).and_return(msg)
        validator2.stub(:error_message).and_return(msg2)

        subject.errors.should == [msg, msg2]
      end
    end
  end
end