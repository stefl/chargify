require 'spec_helper'

describe Chargify::Customer do

  before(:all) do
    Chargify::Config.setup do |config|
      config[:api_key] = 'OU812'
      config[:subdomain] = 'pengwynn'
    end
  end

  describe '.find!' do

    it 'should pass to Chargified::Customer.all' do
      Chargify::Customer.should_receive(:all)
      Chargify::Customer.find!(:all)
    end

    it "should be able to be found by a <chargify_id>" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "customer.json"
      customer = Chargify::Customer.find!(16)
      customer.should be_a(Hashie::Mash)
    end

    it "should raise an error if nothing is found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "", 404
      lambda {
        Chargify::Customer.find!(16)
      }.should raise_error(Chargify::Error::NotFound)
    end

  end
  
  describe '.find' do

    it "should return nil if nothing is found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "", 404
      Chargify::Customer.find(16).should == nil
    end

  end


  describe '.lookup!' do

    it "should be able to be found by a <reference_id>" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/lookup.json?reference=bradleyjoyce", "customer.json"
      customer = Chargify::Customer.lookup!("bradleyjoyce")
      customer.should be_a(Hashie::Mash)
    end

    it "should raise an error if nothing is found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/lookup.json?reference=bradleyjoyce", "", 404
      lambda {
        Chargify::Customer.lookup!("bradleyjoyce")
      }.should raise_error(Chargify::Error::NotFound)
    end

  end
  
  describe '.lookup' do

    it 'should return nil if nothing is found' do
      Chargify::Customer.lookup("bradleyjoyce") == nil
    end

  end


  describe ".all" do

    before do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers.json", "customers.json"
    end

    it "should return a list of customers" do
      customers = Chargify::Customer.all
      customers.size.should == 1
      customers.first.reference.should == 'bradleyjoyce'
      customers.first.organization.should == 'Squeejee'
    end

  end

  describe '.create!' do

    it "should create a new customer" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "new_customer.json"
      info = {
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = Chargify::Customer.create!(info)
      customer.first_name.should == "Wynn"
    end
    
    it "should raise an error if customer creation fails" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "", 422
      lambda {
        Chargify::Customer.create!
      }.should raise_error(Chargify::Error::BadRequest)
    end

  end
  
  describe '.create' do
    
    it "should return false if creation fails" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "", 422
      Chargify::Customer.create.should == false
    end
    
  end
  
  describe '.find_or_create' do
    it "should create a user" do

    end
    
    it "should supress BadRequest error and lookup" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "", 422
      info = {
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com",
        :reference    => "wynn@example.com"
      }
      
      Chargify::Customer.should_receive(:lookup)
      lambda {
        Chargify::Customer.find_or_create(info)
      }.should_not raise_error(Chargify::Error::BadRequest)
    end

  end

  describe '.update!' do

    it "should update a customer" do
      stub_put "https://OU812:x@pengwynn.chargify.com/customers/16.json", "new_customer.json"
      info = {
        :id           => 16,
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = Chargify::Customer.update!(info)
      customer.first_name.should == "Wynn"
    end
    
    it "should raise an error if the customer cannot be found" do
      stub_put "https://OU812:x@pengwynn.chargify.com/customers/16.json", "", 404
      lambda {
        Chargify::Customer.update!(:id => 16)
      }.should raise_error(Chargify::Error::NotFound)
    end

  end
  
  describe '.update' do
    
    it "should return false if the customer cannot be found" do
      stub_put "https://OU812:x@pengwynn.chargify.com/customers/16.json", "", 404
      Chargify::Customer.update(:id => 16).should == false
    end
    
  end

  describe '.subscriptions' do

    it "should return a list of customer subscriptions" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16/subscriptions.json", "subscriptions.json"
      subscriptions = Chargify::Customer.subscriptions(16)
      subscriptions.size.should == 1
      subscriptions.first.customer.reference.should == "bradleyjoyce"
    end

  end

end
