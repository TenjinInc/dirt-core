require 'dirt'

describe Dirt::Context do
  describe '#run' do
    it 'should create an instance and call #call on it' do
      Dirt::Context.any_instance.should_receive(:call)

      Dirt::Context.run(double('params'))
    end

    it 'should pass forward params to #new' do
      args = double('params')

      Dirt::Context.should_receive(:new).with(args).and_call_original

      Dirt::Context.run(args)
    end
  end

  describe '#initialize' do
    it 'should accept no param' do
      Dirt::Context.new()
    end

    it 'should accept params' do
      args = double('params')

      Dirt::Context.new(args)
    end
  end
end