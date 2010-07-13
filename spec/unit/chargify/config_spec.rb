require 'spec_helper'

describe Chargify::Config do

  before :each do

    Chargify::Config.clear
    Chargify::Config.setup do |c|
      c[:one] = 1
      c[:two] = 2
    end

  end

  describe "logger" do

    before :each do
      Object.send(:remove_const, :RAILS_DEFAULT_LOGGER) if defined?(RAILS_DEFAULT_LOGGER)
    end

    it "should default to RAILS_DEFAULT_LOGGER if defined" do
      pending
      Rails.logger = "something"
      Chargify::Config.reset
      Chargify::Config.logger.should == "something"
    end

    it "should default to a Logger if RAILS_DEFAULT_LOGGER is not defined" do
      Chargify::Config.reset
      Chargify::Config.logger.should be_a(Logger)
    end

  end

  describe "configuration" do

    it "should return the configuration hash" do
      Chargify::Config.configuration.should == {:one => 1, :two => 2}
    end

  end

  describe "[]" do

    it "should return the config option matching the key" do
      Chargify::Config[:one].should == 1
    end

    it "should return nil if the key doesn't exist" do
      Chargify::Config[:monkey].should be_nil
    end

  end

  describe "[]=" do

    it "should set the config option for the key" do
      lambda{
        Chargify::Config[:banana] = :yellow
      }.should change(Chargify::Config, :banana).from(nil).to(:yellow)
    end

  end

  describe "delete" do

    it "should delete the config option for the key" do
      lambda{
        Chargify::Config.delete(:one)
      }.should change(Chargify::Config, :one).from(1).to(nil)
    end

    it "should leave the config the same if the key doesn't exist" do
      lambda{
        Chargify::Config.delete(:test)
      }.should_not change(Chargify::Config, :configuration)
    end

  end

  describe "fetch" do

    it "should return the config option matching the key if it exists" do
      Chargify::Config.fetch(:one, 100).should == 1
    end

    it "should return the config default if the key doesn't exist" do
      Chargify::Config.fetch(:other, 100).should == 100
    end

  end

  describe "to_hash" do

    it "should return a hash of the configuration" do
      Chargify::Config.to_hash.should == {:one => 1, :two => 2}
    end

  end

  describe "setup" do

    it "should yield self" do
      Chargify::Config.setup do |c|
        c.should == Chargify::Config
      end
    end

    it "should let you set items on the configuration object as a hash" do
      lambda {
        Chargify::Config.setup do |c|
          c[:bananas] = 100
        end
      }.should change(Chargify::Config, :bananas).from(nil).to(100)
    end

    it "should let you set items on the configuration object as a method" do
      lambda {
        Chargify::Config.setup do |c|
          c.monkeys = 100
        end
      }.should change(Chargify::Config, :monkeys).from(nil).to(100)
    end

  end

  describe "calling a missing method" do

    it "should retreive the config if the method matches a key" do
      Chargify::Config.one.should == 1
    end

    it "should retreive nil if the method doesn't match a key" do
      Chargify::Config.moo.should be_nil
    end

    it "should set the value of the config item matching the method name if it's an assignment" do
      lambda {
        Chargify::Config.trees = 3
      }.should change(Chargify::Config, :trees).from(nil).to(3)
    end

  end

end


