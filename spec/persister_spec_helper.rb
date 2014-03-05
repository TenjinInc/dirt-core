# To use Persister shared examples, supply +it_behaves_like(:persister)+ with:
# * +:persisted+ - An instance to be saved to the persister that matches +where_params+
# * +:persisted2+ - An instance to be saved to the persister that matches +where_params+
# * +:different_persisted+ - An instance to be saved to the persister that does *not* match +where_params+
# * +:where_params+ - The parameter hash given to #where()
#
# using, for example, the block syntax
shared_examples_for(:persister) do
  let(:id) { 1 }

  describe '#save' do
    context 'one arg' do
      it { should respond_to(:save).with(1).arguments }

      it 'should return an object with an id' do
        subject.save(persisted).should respond_to(:id)
      end
    end

    context 'specific id' do
      it { should respond_to(:save).with(2).arguments }

      it 'should return an object with an id' do
        subject.save(persisted, id).should respond_to(:id)
      end

      it 'should return an object that can to_hash' do
        subject.save(persisted, id).should respond_to(:to_hash)
      end
    end
  end

  describe '#load' do
    before(:each) do
      subject.save(persisted, id)
    end

    it { should respond_to(:load).with(1).argument }

    it 'should return an object with an id' do
      subject.load(id).should respond_to(:id)
    end

    it 'should return an object that can to_hash' do
      subject.load(id).should respond_to(:to_hash)
    end
  end

  describe '#delete' do
    before(:each) do
      subject.save(persisted, id)
    end

    it { should respond_to(:delete).with(1).argument }

    it 'should return an object with an id' do
      subject.delete(id).should respond_to(:id)
    end

    it 'should return an object that can to_hash' do
      subject.delete(id).should respond_to(:to_hash)
    end
  end

  describe '#exists?' do
    it { should respond_to(:exists?) }

    context 'it does' do
      before(:each) do
        subject.save(persisted, id)
      end

      it 'should return true' do
        subject.exists?(id).should be_true
      end
    end

    context 'it does not' do
      it 'should return true' do
        subject.exists?(id).should be_false
      end
    end
  end

  describe '#all' do
    it { should respond_to(:all) }

    before(:each) do
      subject.save(persisted)
      subject.save(persisted2)
    end

    it 'should return an array' do
      subject.all.should be_a Array
    end

    it 'should return all objects' do
      subject.all.size.should == 2
    end

    it 'should return an array of id-having objects' do
      subject.all.each { |o| o.should respond_to(:id) }
    end

    it 'should return an array of to_hash-capable objects' do
      subject.all.each { |o| o.should respond_to(:to_hash) }
    end
  end

  describe '#where' do
    before(:each) do
      subject.save(persisted)
      subject.save(different_persisted)
      subject.save(persisted2)
    end

    it { should respond_to(:where).with(1).argument }

    it 'should return a relation' do
      subject.where(where_params).should be_a Relation
    end

    it 'should return only matching results' do
      subject.where(where_params).collect { |id, data| data }.should == [persisted, persisted2]
    end
  end

  describe '#find' do
    before(:each) do
      subject.save(different_persisted)
      subject.save(persisted)
      subject.save(persisted2)
    end

    it { should respond_to(:find).with(1).argument }

    it 'should return an object with an id' do
      subject.find(where_params).should respond_to(:id)
    end

    it 'should return an object that can to_hash' do
      subject.find(where_params).should respond_to(:to_hash)
    end

    it 'should return the first matching result' do
      subject.find(where_params).should == OpenStruct.new(persisted.to_hash.merge(id: 2))
    end
  end
end