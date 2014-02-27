require 'spec_helper'
require './lib/roles/persisting'
require './lib/persisters/memory_persister'

describe Persisting do
  let(:decorated) { double('decorated') }

  subject do
    Persisting.new(decorated)
  end

  let(:persister) { MemoryPersister.new(:mock) }

  before(:each) do
    Persister.for(:mock, persister)
  end

  after(:each) do
    Persister.clear
  end

  describe '#initialize' do
    it 'should save the given id' do
      id = 5
      p = Persisting.new(decorated, id)
      p.id.should == id
    end
  end

  describe '#==' do
    context 'same id' do
      let(:decorated) { [5] }

      it 'should be equal with equivalent contents' do
        clone = [5]
        decorated.should == clone
        subject.should == Persisting.new(clone)
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
      let(:saved) { {id => double('a saved thingy')} }

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

        it 'should remember the id assinged by persister' do
          persister.stub(:save).and_return({id => decorated})

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
      let(:id) { double('id') }
      let(:decorated_hash) { double('decorated\'s hash') }

      before(:each) do
        persister.save(decorated, id)
        decorated.stub(:to_hash).and_return(decorated_hash)
      end

      it 'should load the persisted object into itself' do
        decorated.should_receive(:update).with(decorated_hash)

        subject.load(id)
      end

      it 'should keep the id' do
        decorated.stub(:update)

        subject.load(id).id.should == id
      end

      it 'should return itself' do
        decorated.stub(:update)

        subject.load(id).should be subject
      end
    end

    context 'no record has that id' do
      it 'should explode' do
        expect { subject.load(double('id')) }.to raise_error(MissingRecordError)
      end
    end
  end

  context '#load_by' do
    let(:attr) { :test_attr }
    let(:value) { double('test value') }

    let(:id1) { double('id1') }
    let(:id2) { double('id2') }
    let(:id3) { double('id3') }

    let(:record1) { double('record1') }
    let(:record2) { double('record2') }
    let(:record3) { double('record3') }

    before(:each) do
      persister.save(record1, id1)
      persister.save(record2, id2)
      persister.save(record3, id3)
    end

    context 'there is a record by that attribute' do
      let(:record_hash) { double('record2\'s hash') }

      before(:each) do
        record1.stub(attr).and_return(double('something else'))
        record2.stub(attr).and_return(double('something else'))
        record3.stub(attr).and_return(value)

        record3.stub(:to_hash).and_return(record_hash)
      end

      it 'should load the persisted object into itself' do
        decorated.should_receive(:update).with(record_hash)

        subject.load_by(attr => value)
      end

      it 'should return itself' do
        decorated.stub(:update)

        subject.load_by(attr => value).should be subject
      end

      it 'should keep the found id' do
        decorated.stub(:update)

        subject.load_by(attr => value).id.should == id3
      end
    end

    context 'multiple records have that attribute' do
      let(:record_hash) { double('record2\'s hash') }

      before(:each) do
        record1.stub(attr).and_return(double('something else'))
        record2.stub(attr).and_return(value)
        record3.stub(attr).and_return(value)

        record2.stub(:to_hash).and_return(record_hash)
      end

      it 'should load the first matching persisted object into itself' do
        decorated.should_receive(:update).with(record_hash)

        subject.load_by(attr => value)
      end

      it 'should return itself' do
        decorated.stub(:update)

        subject.load_by(attr => value).should be subject
      end

      it 'should keep the found id' do
        decorated.stub(:update)

        subject.load_by(attr => value).id.should == id2
      end
    end

    context 'no record has that attribute' do
      before(:each) do
        record1.stub(attr).and_return(double('something else'))
        record2.stub(attr).and_return(double('something else'))
        record3.stub(attr).and_return(double('something else'))
      end

      it 'should NOT load the persisted object but explode' do
        decorated.should_not_receive(:update)

        expect { subject.load_by(attr => value) }.to raise_error(MissingRecordError, "No record matches #{attr} == #{value}.")
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
end