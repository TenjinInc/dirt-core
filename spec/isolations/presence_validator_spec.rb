require './spec/isolations/spec_helper'

describe PresenceValidator do
  let(:decorated) { double('decorated', test_property: nil) }
  subject { PresenceValidator.new(:test_property) }

  describe '#valid?' do
    context 'decorated object has a value at that field' do
      it 'should return true on object' do
        decorated.stub(:test_property).and_return(double('real value'))

        subject.valid?(decorated).should be true
      end

      it 'should return true on non-empty string' do
        decorated.stub(:test_property).and_return('real value')

        subject.valid?(decorated).should be true
      end
    end

    context 'decorated object has nil/empty string at that field' do
      it 'should return false on empty string' do
        decorated.stub(:test_property).and_return('')

        subject.valid?(decorated).should be false
      end

      it 'should return false on whitespace string' do
        decorated.stub(:test_property).and_return(" \t\r\n\f")

        subject.valid?(decorated).should be false
      end

      it 'should return false on nil' do
        subject.valid?(decorated).should be false
      end
    end
  end
end