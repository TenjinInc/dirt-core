require 'bdd/spec_helper'
require 'roles/validation/existence_validator'

describe ExistenceValidator do
  let(:persister) { double('persister') }
  let(:decorated) { double('decorated') }
  let(:is_list) { false }

  subject { ExistenceValidator.new(:some_reference, {as: :some_class, list: is_list}) }

  before(:each) do
    Persister.for(:some_class, persister)
  end

  after(:each) do
    Persister.clear
  end

  describe '#initialize' do
    it 'should explode when as: is not supplied' do
      expect { ExistenceValidator.new(decorated, {}) }.to raise_error(ArgumentError)
    end
  end

  describe '#valid?' do
    it 'should return false if given nil' do
      subject.valid?(nil).should be false
    end

    context 'single' do
      before(:each) do
        decorated.stub(:some_reference_id).and_return(double('id'))
      end

      it 'should return true when persister has something by the id' do
        persister.stub(:exists?).and_return(true)

        subject.valid?(decorated).should be true
      end

      it 'should return false when persister has nothing by the id' do
        persister.stub(:exists?).and_return(false)

        subject.valid?(decorated).should be false
      end
    end

    context 'list' do
      subject { ExistenceValidator.new(:some_reference_ids, {as: :some_class, list: true}) }

      before(:each) do
        decorated.stub(:some_reference_ids).and_return([double('id1'), double('id2'), double('id3')])
      end

      it 'should return true when persister has something for every id' do
        persister.stub(:exists?).and_return(true, true, true)

        subject.valid?(decorated).should be true
      end

      it 'should return false when persister has nothing for an id' do
        persister.stub(:exists?).and_return(true, false, true)

        subject.valid?(decorated).should be false
      end
    end
  end

  describe '#errors' do
    context 'valid? not called previously' do
      it 'should return nil' do
        subject.error_message(decorated).should be nil
      end
    end

    context 'single' do
      let(:id) { double('id') }
      before(:each) do
        decorated.stub(:some_reference_id).and_return(id)
      end

      it 'should return nil when persister has something for the id' do
        persister.stub(:exists?).and_return(true)
        subject.valid?(decorated)

        subject.error_message(decorated).should be nil
      end

      it 'should return an error when persister has nothing for the id' do
        persister.stub(:exists?).and_return(false)
        subject.valid?(decorated)

        subject.error_message(decorated).should == "That some_class (id: #{id}) does not exist."
      end
    end

    context 'list' do
      subject { ExistenceValidator.new(:some_reference_ids, {as: :some_class, list: true}) }
      let(:id1) { double('id1') }
      let(:id2) { double('id2') }
      let(:id3) { double('id3') }

      before(:each) do
        decorated.stub(:some_reference_ids).and_return([id1, id2, id3])
      end

      it 'should return nil when persister has something for every id' do
        persister.stub(:exists?).and_return(true, true, true)
        subject.valid?(decorated)

        subject.error_message(decorated).should be nil
      end

      it 'should return an error when persister has nothing for an id' do
        persister.stub(:exists?).and_return(false, false, false)
        subject.valid?(decorated)

        subject.error_message(decorated).should == "Those some_classes (ids: #{[id1, id2, id3].join(", ")}) do not exist."
      end

      it 'should return include only the failed when persister has nothing for an id' do
        persister.stub(:exists?).and_return(true, false, false)
        subject.valid?(decorated)

        subject.error_message(decorated).should == "Those some_classes (ids: #{[id2, id3].join(", ")}) do not exist."
      end
    end
  end
end