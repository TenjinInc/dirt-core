# To use Persister shared examples, supply +it_behaves_like(:persister)+ with:
# * +:persisted+ - An instance to be saved to the persister that matches +where_params+
# * +:persisted2+ - An instance to be saved to the persister that matches +where_params+
# * +:different_persisted+ - An instance to be saved to the persister that does *not* match +where_params+
# * +:where_params+ - The parameter hash given to #where()
#
# using, for example, the block syntax
shared_examples_for(:persister) do
  describe '#new' do
    context 'no args' do
      it 'should return a non-nil' do
        subject.new.should_not be_nil
      end
    end

    context 'some args' do
      before(:each) do
        @new_obj = subject.new(where_params)
      end
      it 'should populate each parameter' do
        where_params.each do |key, val|
          @new_obj.send(key).should == val
        end
      end
    end
  end

  describe '#save' do
    context 'one arg' do
      it { should respond_to(:save).with(1).arguments }

      it 'should return an object with an id' do
        subject.save(persisted).should respond_to(:id)
      end
    end

    context 'specific id' do
      it { should respond_to(:save).with(2).arguments }

      context 'it pre-exists' do
        let(:id) { subject.save(persisted).id }

        it 'should return an object with an id' do
          subject.save(persisted, id).should respond_to(:id)
        end

        it 'should return an object that can to_hash' do
          subject.save(persisted, id).should respond_to(:to_hash)
        end
      end

      context 'it does not exist' do
        let(:id) { 1 }

        it 'should raise an error' do
          expect { subject.save(persisted, id) }.to raise_error(Dirt::MissingRecordError, "That #{persisted.class.to_s.demodulize} (id: 1) does not exist.")
        end
      end
    end
  end

  describe '#load' do
    context 'it exists' do
      let(:id) { subject.save(persisted).id }

      it { should respond_to(:load).with(1).argument }

      it 'should return an object with an id' do
        subject.load(id).should respond_to(:id)
      end

      it 'should return an object that can to_hash' do
        subject.load(id).should respond_to(:to_hash)
      end
    end

    context 'it does not exist' do
      let(:id) { 1 }

      it 'should raise an error' do
        expect { subject.load(id) }.to raise_error(Dirt::MissingRecordError, "That #{persisted.class.to_s.demodulize} (id: #{id}) does not exist.")
      end
    end
  end

  describe '#delete' do
    it { should respond_to(:delete).with(1).argument }

    context 'exists' do
      let(:id) { subject.save(persisted).id }

      it 'should return true' do
        subject.delete(id).should == OpenStruct.new(persisted.to_hash.merge(id: id))
      end
    end

    context 'does not exist' do
      let(:id) { 1 }

      it 'should return false' do
        subject.delete(id).should be nil
      end
    end
  end

  describe '#exists?' do
    it { should respond_to(:exists?) }

    context 'it does' do
      let(:id) { subject.save(persisted).id }

      it 'should return true' do
        subject.exists?(id).should == true
      end
    end

    context 'it does not' do
      let(:id) { 1 }

      it 'should return true' do
        subject.exists?(id).should == false
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
      @id_match1 = subject.save(persisted).id
      subject.save(different_persisted)
      @id_match2 = subject.save(persisted2).id
    end

    it { should respond_to(:where).with(1).argument }

    it 'should return only matching results' do
      all = subject.where(where_params).all? do |data|
        where_params.all? { |key, value| data.send(key) == value }
      end

      all.should be_true
    end

    it 'should the correct matching results' do
      subject.where(where_params).collect do |record|
        record.id
      end.should == [@id_match1, @id_match2]
    end

    describe 'relation returned' do
      let(:relation) { subject.where(where_params) }

      # This is true of ActiveRecord relations, but not of DataMapper collections.
      # it 'should respond to where' do
      #   relation.should respond_to(:where)
      # end

      it 'should respond to first' do
        relation.should respond_to(:first)
      end

      it 'should respond to all?' do
        relation.should respond_to(:all?)
      end
    end
  end

  describe '#find' do
    before(:each) do
      subject.save(different_persisted)
      @id = subject.save(persisted).id
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
      subject.find(where_params).id.should == @id
    end
  end
end