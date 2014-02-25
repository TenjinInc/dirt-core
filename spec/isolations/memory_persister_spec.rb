require 'spec_helper'
require 'persisters/memory_persister'

describe MemoryPersister do
  describe '#save' do
    it 'should return the id and data as a hash on success' do
      id = double('id')
      data = double('data')

      result = subject.save(data, id)

      result.should == {id => data}
    end

    it 'should remember the data by the given id' do
      id = 3
      data = double('data')

      subject.save(data, id)

      subject.instance_variable_get(:@records).should == {id => data}
    end

    it 'should remember the data by a made up id when none given' do
      data = double('data')

      subject.save(data, nil)

      subject.instance_variable_get(:@records).should == {1 => data}
    end
  end

  describe '#load' do
    it 'should return the id and data as a hash' do
      id = double('id')
      data = double('data')

      subject.instance_variable_set(:@records, {id => data})

      subject.load(id).should == {id => data}
    end

    it 'should return only the appropriate id and data' do
      id = double('id')
      data = double('data')

      subject.instance_variable_set(:@records, {id => data, double('id2') => double('data2')})

      subject.load(id).should == {id => data}
    end

    it 'should raise exception when given an invalid id' do
      id = double('id3')

      subject.instance_variable_set(:@records, {double('id') => double('data'), double('id2') => double('data2')})

      expect { subject.load(id) }.to raise_error(MissingRecordError, "No record can be found for id #{id}.")
    end
  end

  describe '#exists?' do
    it 'should return only the appropriate id and data' do
      id = double('id')
      data = double('data')

      subject.instance_variable_set(:@records, {id => data})

      subject.exists?(id).should be true
    end

    it 'should raise exception when given an invalid id' do
      id = double('id3')

      subject.instance_variable_set(:@records, {double('id') => double('data'), double('id2') => double('data2')})

      subject.exists?(id).should be false
    end
  end

  describe '#all' do
    it 'should return all of the appropriate id and data' do
      records = {double('id1') => double('data1'),
                 double('id2') => double('data2'),
                 double('id3') => double('data3')}

      subject.instance_variable_set(:@records, records)

      subject.all.should == records
    end
  end

  describe '#delete' do
    it 'should return the deleted id and data as a hash' do
      id = double('id')
      records = {id => double('data')}

      subject.instance_variable_set(:@records, records.dup)

      subject.delete(id).should == records
    end

    it 'should delete the given id and data' do
      id = double('id')
      data = double('data')

      subject.instance_variable_set(:@records, {id => data})

      subject.delete(id)

      subject.instance_variable_get(:@records).should == {}
    end

    it 'should delete only the appropriate id and data' do
      id1 = double('id1')
      id2 = double('id2')
      data1 = double('data1')
      data2 = double('data2')

      subject.instance_variable_set(:@records, {id1 => data1, id2 => data2})

      subject.delete(id1)

      subject.instance_variable_get(:@records).should == {id2 => data2}
    end

    it 'should raise exception when given an invalid id' do
      id = double('id3')

      subject.instance_variable_set(:@records, {double('id') => double('data'), double('id2') => double('data2')})

      expect { subject.delete(id) }.to raise_error(MissingRecordError, "No record can be found for id #{id}.")
    end
  end
end