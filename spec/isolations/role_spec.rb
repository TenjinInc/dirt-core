require "rspec"
require './lib/roles/role'

module Scheduler
  describe Role do
    let(:decorated) { double('decorated', test_method: nil) }

    subject do
      Role.new(decorated)
    end

    describe '#method_missing' do
      context 'the method is supported' do
        before(:each) { decorated.stub(:respond_to?).and_return(true) }

        it 'should call the method on the decorated object' do
          decorated.should_receive(:test_method).with([], nil)

          subject.method_missing(:test_method, [], nil)
        end
      end

      context 'the method is not supported' do
        before(:each) { decorated.stub(:respond_to?).and_return(false) }

        it 'should call the method on the decorated object' do
          decorated.should_not_receive(:test_method)

          expect { subject.method_missing(:test_method, [], nil) }.to raise_error(NoMethodError)
        end
      end
    end

    describe '#respond_to?' do
      context 'the method is supported directly' do
        before(:each) { subject.stub(:test_method) }

        it 'should return true' do
          decorated.should_not_receive(:respond_to?)

          subject.respond_to?(:test_method).should == true
        end
      end

      context 'the method is not supported directly' do
        it 'should ask the decorated object' do
          decorated.should_receive(:respond_to?).with(:test_method, false).and_return(true)

          subject.respond_to?(:test_method).should == true
        end
      end

      context 'the method is not supported at all' do
        it 'should ask the decorated object' do
          decorated.should_receive(:respond_to?).with(:another_method, false).and_return(false)

          subject.respond_to?(:another_method).should == false
        end
      end
    end

    describe '#== ' do
      it 'should be equal with identical contents' do
        subject.should == Persisting.new(decorated)
      end

      it 'should equal itself' do
        subject.should == subject
      end

      it 'should equal the decorated object' do
        subject.should == decorated
      end

      it 'should not equal a different object' do
        subject.should_not == double('something else entirely')
      end

      context 'equivalent contents' do
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
  end
end