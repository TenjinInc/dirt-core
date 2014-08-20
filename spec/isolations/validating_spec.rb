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