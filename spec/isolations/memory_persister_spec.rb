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

require 'dirt/bdd/persister_spec_helper'
require './spec/isolations/spec_helper'

module Dirt
  describe MemoryPersister do
    let(:type) { :test }
    subject do
      MemoryPersister.new(:Mock) do |*args|
        double('Persisting', *args)
      end
    end

    it_behaves_like(:persister) do
      let(:persisted) { double('persisted object', attr1: 5, to_hash: {attr1: 5}) }
      let(:persisted2) { double('persisted object 2', attr1: 5, to_hash: {attr1: 5}) }
      let(:different_persisted) { double('different persisted object', attr1: 28, to_hash: {attr1: 28}) }

      let(:where_params) { {attr1: 5} }
    end

    describe '#new' do
      it 'should explode when not given a block' do
        expect { MemoryPersister.new(:some_type).new }.to raise_error(RuntimeError, 'Cannot create a new instance without a block given to init.')
      end

      it 'should return an object' do
        subject.new.should_not be_nil
      end

      context 'called with args' do
        it 'should populate the new object with args data' do
          subject.new(arg1: 'val1').arg1.should == 'val1'
        end
      end
    end

    describe '#save' do
      let(:data) { double('data', to_hash: {some: 'data'}) }

      it 'should return the id + data as struct on success' do
        result = subject.save(data)

        result.should == OpenStruct.new(data.to_hash.merge(id: result.id))
      end

      it 'should remember the data by the given id' do
        id = 3

        fake1 = double('other data', to_hash: {})
        fake2 = double('another data', to_hash: {})

        subject.save(fake1)
        subject.save(fake2)
        subject.save(double('replaced', to_hash: {}))
        subject.save(data, id)

        subject.instance_variable_get(:@records).should == {1 => fake1, 2 => fake2, id => data}
      end

      it 'should remember the data by a made up id when none given' do
        subject.save(data, nil)

        subject.instance_variable_get(:@records).should == {1 => data}
      end
    end

    describe '#load' do
      let(:data) { double('data', to_hash: {some: 'data'}) }

      it 'should return only the appropriate id and data' do
        id = double('id')

        subject.instance_variable_set(:@records, {id => data, double('id2') => double('data2')})

        subject.load(id).should == OpenStruct.new(data.to_hash.merge(id: id))
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
        records = {double('id1') => double('data1', to_hash: {attr1: double}),
                   double('id2') => double('data2', to_hash: {attr1: double}),
                   double('id3') => double('data3', to_hash: {attr1: double})}

        subject.instance_variable_set(:@records, records)

        subject.all.should == records.collect { |id, r| OpenStruct.new(r.to_hash.merge(id: id)) }
      end
    end

    describe '#delete' do
      let(:data) { double('data', to_hash: {some: 'data'}) }

      it 'should return the deleted id and data as a struct' do
        id = double('id')

        subject.instance_variable_set(:@records, {id => data})

        subject.delete(id).should == OpenStruct.new(data.to_hash.merge(id: id))
      end

      it 'should delete the given id and data' do
        id = double('id')

        subject.instance_variable_set(:@records, {id => data})

        subject.delete(id)

        subject.instance_variable_get(:@records).should == {}
      end

      it 'should delete only the appropriate id and data' do
        id1 = double('id1')
        id2 = double('id2')
        data2 = double('data2')

        subject.instance_variable_set(:@records, {id1 => data, id2 => data2})

        subject.delete(id1)

        subject.instance_variable_get(:@records).should == {id2 => data2}
      end

      it 'should return nil when given an invalid id' do
        id = double('id3')

        subject.instance_variable_set(:@records, {double('id') => double('data'), double('id2') => double('data2')})

        subject.delete(id).should == nil
      end
    end
  end
end