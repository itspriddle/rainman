require 'spec_helper'

describe Rainman::Runner do
  before do
    @handler = mock("Handler")
    @handler.stub(:hi).and_return(:salutations)
    @handler.stub(:new).and_return(@handler)
  end

  let(:handler)  { @handler }
  let(:handlers) { subject.class.handlers }
  subject        { Rainman::Runner.new(:hello, handler) }

  context "Accessors" do
    its(:handler) { should eql(handler) }
  end

  describe "::handlers" do
    it "returns a hash" do
      handlers.should be_a Hash
      handlers[:hello].should eq subject
    end

    it "raises exception when accessing an unknown key" do
      expect { handlers[:foo] }.to raise_error(Rainman::InvalidHandler)
    end

    it "raises exception when accessing a nil key" do
      expect { handlers[nil] }.to raise_error(Rainman::NoHandler)
    end
  end

  describe "#method_missing" do
    it "should delegate to the handler" do
      args = { :arg => 1 }
      handler.should_receive(:hi).with(args).once
      subject.hi(args)
    end

    it { expect { subject.missing }.to raise_error(NoMethodError) }
  end
end
