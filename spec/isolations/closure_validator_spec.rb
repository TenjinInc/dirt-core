require 'spec/spec_helper'
require 'roles/validation/closure_validator'

describe ClosureValidator do
  let(:expected_validity) { double('validity') }
  let(:expected_error) { double('error') }

  describe 'closure use' do
    subject do
      ClosureValidator.new(lambda { |val| expected_validity }, lambda { |err| expected_error })
    end

    it 'should use the block to determines validity' do
      subject.valid?(expected_validity).should be expected_validity
    end

    it 'should use the second block to determine the error' do
      subject.error_message(expected_error).should be expected_error
    end
  end

  describe 'parameters' do
    subject do
      ClosureValidator.new(lambda { |val| val }, lambda { |err| err })
    end

    it 'should pass the validated object into the valid? closure' do
      subject.valid?(expected_validity).should be expected_validity
    end

    it 'should pass the validated object into the error closure' do
      subject.error_message(expected_error).should be expected_error
    end
  end
end