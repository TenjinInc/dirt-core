require 'bdd/spec_helper'
require 'roles/validation/self_existence_validator'

describe SelfExistenceValidator do
  let(:id) { double('id') }
  let(:persister) { double('persister') }
  let(:decorated) { double('decorated') }

  subject { SelfExistenceValidator.new(RSpec::Mocks::Mock, id) }

  before(:each) do
    Persister.for(RSpec::Mocks::Mock, persister)
  end

  after(:each) do
    Persister.clear
  end

  describe '#valid?' do
    context 'decorated object exists in the persister' do
      before(:each) do
        persister.stub(:exists?).and_return(true)
      end

      it 'should return true' do
        subject.valid?(decorated).should be true
      end
    end

    context 'decorated object does not exist in persister' do
      before(:each) do
        persister.stub(:exists?).and_return(false)
      end

      it 'should return false' do
        decorated.stub(:test_property).and_return('')

        subject.valid?(decorated).should be false
      end
    end
  end
end