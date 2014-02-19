require './lib/roles/persisting'

describe Persisting do
  let(:decorated) { double('decorated') }

  subject do
    Persisting.new(decorated)
  end

  let(:persister) { double('persister') }

  before(:each) do
    Persister.stub(:for).and_return(persister)
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

    context 'different id' do
      it 'should not be equal' do
        other = Persisting.new(decorated)

        subject.instance_variable_set(:@id, 1)
        other.instance_variable_set(:@id, 2)

        subject.should_not == other
      end
    end
  end

  describe '#save' do
    let(:id) { double('id') }

    context 'persistence completes' do
      let(:saved) { double('a saved thingy', id: id) }

      before(:each) do
        persister.stub(:save).and_return(saved)
      end

      context 'with id' do
        it 'should call persister save with id' do
          persister.should_receive(:save).with(decorated, id)

          subject.save(id)
        end

        it 'should remember the id' do
          subject.save(id)

          subject.id.should == id
        end

        it 'should return itself' do
          subject.save(id).should be subject
        end
      end

      context 'no id' do
        it 'should call persister save with nil id' do
          persister.should_receive(:save).with(decorated, nil)

          subject.save()
        end

        it 'should remember the id' do
          subject.save()

          subject.id.should == id
        end

        it 'should return itself' do
          subject.save(id).should be subject
        end
      end
    end

    context 'persistence fails' do
      before(:each) do
        persister.stub(:save).and_return(nil)
      end

      context 'with id' do
        it 'should call persister save with id' do
          persister.should_receive(:save).with(decorated, id)

          subject.save(id)
        end

        it 'should not remember the id' do
          subject.save(id)

          subject.id.should == nil
        end

        it 'should return nil' do
          subject.save(id).should be nil
        end
      end

      context 'no id' do
        it 'should call persister save with nil id' do
          persister.should_receive(:save).with(decorated, nil)

          subject.save()
        end

        it 'should not remember an id' do
          subject.save()

          subject.id.should == nil
        end

        it 'should return nil' do
          subject.save(id).should be nil
        end
      end
    end
  end

  context '#load' do
    context 'there is a record by that id' do
      it 'should return the persisting wrapped loaded object' do
        loaded = Persisting.new(decorated)

        persister.stub(:load).and_return(loaded)

        subject.load(double('id')).should == loaded
      end
    end

    context 'no record has that id' do
      it 'should return the persisting wrapped loaded object' do
        persister.stub(:load).and_return(nil)

        subject.load(double('id')).should be nil
      end
    end
  end

  context '#delete' do
    context 'there is a record by that id' do
      it 'should return the persisting-wrapped deleted object' do
        deleted = Persisting.new(decorated)

        persister.stub(:delete).and_return(deleted)
        subject.delete(double('an_id')).should == deleted
      end
    end

    context 'no record has that id' do
      it 'should return nil' do
        persister.stub(:delete).and_return(nil)

        subject.delete(double('an_id')).should be nil
      end
    end
  end

  context 'where' do
    pending 'should probably return a list of persistings. actually, why is this in persisting?'
  end
end