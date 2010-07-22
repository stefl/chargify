require 'spec_helper'

describe Chargify::Subscription do

  before(:all) do
    Chargify::Config.setup do |config|
      config[:api_key] = 'OU812'
      config[:subdomain] = 'pengwynn'
    end
  end

  describe '.all' do

    it "should return a list of products" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscriptions.json"
      subscription = Chargify::Subscription.all
      subscription.first.customer.reference.should == 'bradleyjoyce'
    end

  end

  describe '.find!' do

    it "should return info for a subscription" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/13.json", "subscription.json"
      subscription = Chargify::Subscription.find!(13)
      subscription.customer.reference.should == 'bradleyjoyce'
    end

    it "should throw a not found error if a subscription is not found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/18.json", "subscription_not_found.json", 404
      lambda {
        Chargify::Subscription.find!(18)
      }.should raise_error(Chargify::Error::NotFound)
    end

  end
  
  describe '.find' do

    it "should return nil if a subscription is not found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/18.json", "subscription_not_found.json", 404
      Chargify::Subscription.find(18).should == nil
    end

  end

  describe '.create!' do

    it "should create a customer subscription" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = Chargify::Subscription.create!(options)
      subscription.customer.organization.should == 'Squeejee'
    end

    it "should create a customer subscription with a coupon code" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        },
        :coupon_code => "EARLYBIRD"
      }
      subscription = Chargify::Subscription.create!(options)
      subscription.should be_a(Hashie::Mash)
      #subscription.coupon.should == 'Squeejee'
    end

    it "should raise error to true when subscription is created successfully" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 201
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = Chargify::Subscription.create!(options)
      subscription.should be_a(Hashie::Mash)
    end

    it "should raise error to nil when subscription is not created successfully" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 422
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      lambda {
        Chargify::Subscription.create!(options)
      }.should raise_error(Chargify::Error::BadRequest)

    end

    it "should raise UnexpectedResponseError when reponse is invalid JSON" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "invalid_subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      lambda {
        Chargify::Subscription.create!(options)
      }.should raise_error(Chargify::Error::UnexpectedResponse)
    end

  end
  
  describe '.create' do
    
    it "should return false if creation errors out" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 422
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      Chargify::Subscription.create(options).should == false
    end
    
  end

  describe '.update!' do

    it "should update a customer subscription" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = Chargify::Subscription.update!(123, options)
      subscription.customer.organization.should == 'Squeejee'
    end

    it "should raise error to true when subscription is updated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json", 200
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = Chargify::Subscription.update!(123, options)
      subscription.should be_a(Hashie::Mash)
    end

    it "should raise error to false when subscription is not updated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json", 500
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      
      lambda { 
        Chargify::Subscription.update!(123, options) 
      }.should raise_error(Chargify::Error::ServerError)
    end

  end
  
  describe '.update' do
    
    it "should return false if subscription update fails" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json", 500
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      Chargify::Subscription.update(123, options)
    end
    
  end

  describe '.reactivate!' do

    it "should reactivate a subscription" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = Chargify::Subscription.reactivate!(123)
      subscription.state.should == "active"
    end

    it "should raise error to nil when subscription is not reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription_not_found.json", 422
      lambda {
        Chargify::Subscription.reactivate!(123)
      }.should raise_error(Chargify::Error::BadRequest)
    end

    it "should raise error to false when subscription is reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = Chargify::Subscription.reactivate!(123)
      subscription.should be_a(Hashie::Mash)
    end

  end
  
  describe '.reactivate' do

    it "should return false if an error occurs" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription_not_found.json", 422
      Chargify::Subscription.reactivate(123).should == false
    end

  end

  describe '.cancel!' do

    it "should raise error to nil when subscription is not cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 500
      
      lambda { 
        Chargify::Subscription.cancel!(123)
      }.should raise_error(Chargify::Error::ServerError)
    end

    it "should raise error to true when subscription is cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      Chargify::Subscription.cancel!(123).should == true
    end

  end
  
  describe '.cancel' do
    
    it "should return false if an error occurs" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 500
      Chargify::Subscription.cancel(123).should == false
    end

  end

  describe '.charge!' do

      before do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription.json", 201
        @options = {
          :memo   => "This is the description of the one time charge.",
          :amount => 1.00,
          :amount_in_cents => 100
        }
      end

      it "should accept :amount as a parameter" do
        subscription = Chargify::Subscription.charge!(123, @options)

        subscription.should be_a(Hashie::Mash)
        subscription.amount_in_cents.should == @options[:amount]*100
      end

      it "should accept :amount_in_cents as a parameter" do
        subscription = Chargify::Subscription.charge!(123, @options)

        subscription.should be_a(Hashie::Mash)
        subscription.amount_in_cents.should == @options[:amount_in_cents]
      end

      it "should have success? as false if parameters are missing" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription_missing_parameters.json", 422

        lambda {
          Chargify::Subscription.charge!(123, {})
        }.should raise_error(Chargify::Error::BadRequest)
      end

      it "should have success? as false if the subscription is not found" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/9999/charges.json", "", 404

        lambda {
          Chargify::Subscription.charge!(9999, @options)
        }.should raise_error(Chargify::Error::NotFound)
      end

  end
  
  describe '.charge' do

    it "should return false if an error occurs" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription_missing_parameters.json", 422
      Chargify::Subscription.charge(123, {}).should == false
    end

  end

  describe '.migrate!' do

    it "should migrate a subscription from one product to another" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/migrations.json", "migrate_subscription.json"

      subscription = Chargify::Subscription.migrate!(123, 354)
      subscription.should be_a(Hashie::Mash)
      subscription.product.id.should == 354
    end
    
    it "should throw an error if one occurs" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/migrations.json", "", 422
      lambda {
        Chargify::Subscription.migrate!(123, 354)
      }.should raise_error(Chargify::Error::BadRequest)
    end

  end
  
  describe '.migrate' do

    it "should return false if an error occurs" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/migrations.json", "", 422
      Chargify::Subscription.migrate(123, 354).should == false
    end

  end

  describe '.components!' do

    it "should list components" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components.json", "components.json"
      components = Chargify::Subscription.components(123)
      components.first.allocated_quantity.should == 42
      components.last.allocated_quantity.should == 2
    end

    it "should throw an error if one occurs"

  end
  
  describe '.components' do
    
    it 'should return false if an error occurs'
    
  end

  describe '.find_component!' do

    it "should show a specific component" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/16.json", "component.json"
      component = Chargify::Subscription.find_component!(123, 16)
      component.name.should == "Extra Rubies"
      component.allocated_quantity.should == 42
    end

    it "should throw an error if one occurs"

  end
  
  describe '.find_component!' do
    
    it 'should return false if an error occurs'
    
  end

  describe '.update_component!' do

    it "should update the allocated_quantity for a component" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/16.json", "component.json"
      response = Chargify::Subscription.update_component!(123, 16, 20_000_000)
      response.should be_a(Hashie::Mash)
    end
    
    it "should throw an error if one occurs"

  end

  describe '.update_component' do
    
    it 'should return false if an error occurs'
    
  end

  describe '.component_usage!' do

    it "should list usage for a subscription" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/456/usages.json", "list_metered_subscriptions.json", 200

      subscription = Chargify::Subscription.component_usage(123, 456)
      subscription.should be_a(Hashie::Mash)
    end
    
    it "should throw an error if one occurs"

  end
  
  describe '.component_usage' do
    
    it 'should return false if an error occurs'
    
  end

end
