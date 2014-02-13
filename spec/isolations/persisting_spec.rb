require './lib/roles/persisting'

describe Persisting do
  let(:decorated) { double('decorated') }

  subject do
    Persisting.new(decorated)
  end

  describe '#==' do
    context 'same id' do
      it 'should be equal with identical contents' do
        subject.should == Persisting.new(decorated)
      end

      it 'should equal itself' do
        subject.should == subject
      end

      context 'equilavent contents' do
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

  context 'diff id' do
    it 'should not be equal' do
      other = Persisting.new(decorated)

      subject.instance_variable_set(:@id, 1)
      other.instance_variable_set(:@id, 2)

      subject.should_not == other
    end
  end
end