require 'spec_helper'

describe Chargify::Subscription do

  before(:all) do
    Chargify::Config.setup do |config|
      config[:api_key] = 'OU812'
      config[:subdomain] = 'pengwynn'
    end
  end

  describe '.find' do

    it "should return info for a subscription" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/13.json", "subscription.json"
      subscription = Chargify::Subscription.find(13)
      subscription.customer.reference.should == 'bradleyjoyce'
    end

    it "should return nil if a subscription is not found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/18.json", "subscription_not_found.json", 404
      subscription = Chargify::Subscription.find(18)
      subscription.should == nil
    end

  end

  describe '.create' do

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
      subscription = Chargify::Subscription.create(options)
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
      subscription = Chargify::Subscription.create(options)
      #subscription.coupon.should == 'Squeejee'
    end

    it "should set success? to true when subscription is created successfully" do
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
      subscription = Chargify::Subscription.create(options)
      subscription.success?.should == true
    end

    it "should set success? to nil when subscription is not created successfully" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 400
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = Chargify::Subscription.create(options)
      subscription.success?.should == nil
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
        Chargify::Subscription.create(options)
      }.should raise_error(Chargify::UnexpectedResponseError)
    end
  end

  describe '.update' do

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
      subscription = Chargify::Subscription.update(123, options)
      subscription.customer.organization.should == 'Squeejee'
    end

    it "should set success? to true when subscription is updated successfully" do
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
      subscription = Chargify::Subscription.update(123, options)
      subscription.success?.should == true
    end

    it "should set success? to false when subscription is not updated successfully" do
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
      subscription = Chargify::Subscription.update(123, options)
      subscription.success?.should == nil
    end

  end

  describe '.reactivate' do

    it "should reactivate a subscription" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = Chargify::Subscription.reactivate(123)

      subscription.state.should == "active"
    end

    it "should set success? to nil when subscription is not reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription_not_found.json", 500
      subscription = Chargify::Subscription.reactivate(123)

      subscription.success?.should == nil
    end

    it "should set success? to false when subscription is reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = Chargify::Subscription.reactivate(123)

      subscription.success?.should == true
    end

  end

  describe '.cancel' do

    it "should cancel subscription" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = Chargify::Subscription.cancel(123)

      subscription.state.should == "canceled"
    end

    it "should set success? to nil when subscription is not cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 500
      subscription = Chargify::Subscription.cancel(123)

      subscription.success?.should == nil
    end

    it "should set success? to true when subscription is cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = Chargify::Subscription.cancel(123)

      subscription.success?.should == true
    end

  end


  describe '.charge' do

      before do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription.json", 201
        @options = {
          :memo   => "This is the description of the one time charge.",
          :amount => 1.00,
          :amount_in_cents => 100
        }
      end

      it "should accept :amount as a parameter" do
        subscription = Chargify::Subscription.charge(123, @options)

        subscription.amount_in_cents.should == @options[:amount]*100
        subscription.success?.should == true
      end

      it "should accept :amount_in_cents as a parameter" do
        subscription = Chargify::Subscription.charge(123, @options)

        subscription.amount_in_cents.should == @options[:amount_in_cents]
        subscription.success?.should == true
      end

      it "should have success? as false if parameters are missing" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription_missing_parameters.json", 422

        subscription = Chargify::Subscription.charge(123, {})
        subscription.success?.should == false
      end

      it "should have success? as false if the subscription is not found" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/9999/charges.json", "", 404

        subscription = Chargify::Subscription.charge(9999, @options)
        subscription.success?.should == false
      end


  end

end
