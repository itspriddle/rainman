require 'spec_helper'
require File.expand_path('../../example/domain.rb', __FILE__)

describe "Rainman integration" do
  describe Domain do
    describe "handlers" do
      [:enom, :opensrs].each do |hand|
        describe hand do
          subject       { Domain.handlers[hand] }
          it            { should be_a Rainman::Runner }
          its(:config)  { should be_a Hash }
          its(:handler) { should == "Domain::#{hand.to_s.capitalize}".constantize }
        end
      end
    end

    its(:default_handler) { should == :opensrs }

    it "has instance methods for each namespace/action" do
      methods = subject.instance_methods.map(&:to_sym)
      methods.should include(:nameservers, :list, :transfer)
    end

    describe "Opensrs integration" do
      its(:list)              { should == :opensrs_list }
      its(:all)               { should == :opensrs_list }
      its(:transfer)          { should == :opensrs_transfer }
      its("nameservers.list") { should == :opensrs_ns_list }
    end

    describe "Enom integration" do
      before :all do
        subject.set_default_handler :enom
      end

      after :all do
        subject.set_default_handler :opensrs
      end

      its(:list)              { should == :enom_list }
      its(:all)               { should == :enom_list }
      its(:transfer)          { should == :enom_transfer }
      its("nameservers.list") { should == :enom_ns_list }
    end
  end
end
