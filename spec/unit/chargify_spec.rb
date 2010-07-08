require 'spec_helper'

describe Chargify do
  context "Chargify API client" do

    before do
      @client = Chargify::Client.new(:api_key => 'OU812', :subdomain => 'pengwynn')
    end

    it "should return a list of customers" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers.json", "customers.json"
      customers = @client.list_customers
      customers.size.should == 1
      customers.first.reference.should == 'bradleyjoyce'
      customers.first.organization.should == 'Squeejee'
    end

    context "when finding customers" do
      it "should be able to be found by a <reference_id>" do
        stub_get "https://OU812:x@pengwynn.chargify.com/customers/lookup.json?reference=bradleyjoyce", "customer.json"
        customer = @client.customer("bradleyjoyce")
        customer.success?.should == true
      end

      it "should be able to be found by a <chargify_id>" do
        stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "customer.json"
        customer = @client.customer_by_id(16)
        customer.success?.should == true
      end

      it "should return an empty Hash with success? set to false" do
        stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "", 404
        customer = @client.customer_by_id(16)
        customer.success?.should == false
      end
    end

    it "should create a new customer" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "new_customer.json"
      info = {
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = @client.create_customer(info)
      customer.first_name.should == "Wynn"
    end

    it "should update a customer" do
      stub_put "https://OU812:x@pengwynn.chargify.com/customers/16.json", "new_customer.json"
      info = {
        :id           => 16,
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = @client.update_customer(info)
      customer.first_name.should == "Wynn"
    end

    # Depends on Chargify:
    # should_eventually "delete a customer" do
    #
    # end

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
        @client.create_subscription(options)
      }.should raise_error(Chargify::UnexpectedResponseError)
    end

    it "should return a list of customer subscriptions" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16/subscriptions.json", "subscriptions.json"
      subscriptions = @client.customer_subscriptions(16)
      subscriptions.size.should == 1
      subscriptions.first.customer.reference.should == "bradleyjoyce"
    end


    it "should return info for a subscription" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/13.json", "subscription.json"
      subscription = @client.subscription(13)
      subscription.customer.reference.should == 'bradleyjoyce'
    end

    it "should return nil if a subscription is not found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/18.json", "subscription_not_found.json", 404
      subscription = @client.subscription(18)
      subscription.should == nil
    end

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
      subscription = @client.update_subscription(123, options)
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
      subscription = @client.update_subscription(123, options)
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
      subscription = @client.update_subscription(123, options)
      subscription.success?.should == nil
    end

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
      subscription = @client.create_subscription(options)
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
      subscription = @client.create_subscription(options)
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
      subscription = @client.create_subscription(options)
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
      subscription = @client.create_subscription(options)
      subscription.success?.should == nil
    end

    it "should reactivate a subscription" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = @client.reactivate_subscription(123)

      subscription.state.should == "active"
    end

    it "should set success? to nil when subscription is not reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription_not_found.json", 500
      subscription = @client.reactivate_subscription(123)

      subscription.success?.should == nil
    end

    it "should set success? to false when subscription is reactivated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/reactivate.json", "subscription.json", 200
      subscription = @client.reactivate_subscription(123)

      subscription.success?.should == true
    end

    it "should cancel subscription" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = @client.cancel_subscription(123)

      subscription.state.should == "canceled"
    end

    it "should set success? to nil when subscription is not cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 500
      subscription = @client.cancel_subscription(123)

      subscription.success?.should == nil
    end

    it "should set success? to true when subscription is cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = @client.cancel_subscription(123)

      subscription.success?.should == true
    end

    context "when creating a one-off charge for a subscription" do
      before do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription.json", 201
        @options = {
          :memo   => "This is the description of the one time charge.",
          :amount => 1.00,
          :amount_in_cents => 100
        }
      end

      it "should accept :amount as a parameter" do
        subscription = @client.charge_subscription(123, @options)

        subscription.amount_in_cents.should == @options[:amount]*100
        subscription.success?.should == true
      end

      it "should accept :amount_in_cents as a parameter" do
        subscription = @client.charge_subscription(123, @options)

        subscription.amount_in_cents.should == @options[:amount_in_cents]
        subscription.success?.should == true
      end

      it "should have success? as false if parameters are missing" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/charges.json", "charge_subscription_missing_parameters.json", 422

        subscription = @client.charge_subscription(123, {})
        subscription.success?.should == false
      end

      it "should have success? as false if the subscription is not found" do
        stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/9999/charges.json", "", 404

        subscription = @client.charge_subscription(9999, @options)
        subscription.success?.should == false
      end
    end

    context "for metered subscriptions" do

      it "should list usage for a subscription" do
        stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/456/usages.json", "list_metered_subscriptions.json", 200

        subscription = @client.list_subscription_usage(123, 456)
        subscription.success?.should == true
      end

    end

    it "should migrate a subscription from one product to another" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions/123/migrations.json", "migrate_subscription.json"

      subscription = @client.migrate_subscription(123, 354);
      subscription.success?.should == true
      subscription.product.id.should == 354
    end

    it "should return a list of products" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products.json", "products.json"
      products = @client.list_products
      products.first.accounting_code.should == 'TSMO'
    end

    it "should return info for a product" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/8.json", "product.json"
      product = @client.product(8)
      product.accounting_code.should == 'TSMO'
    end

    it "should return info for a product by its handle" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/handle/tweetsaver.json", "product.json"
      product = @client.product_by_handle('tweetsaver')
      product.accounting_code.should == 'TSMO'
    end

    context "for quantity based components" do
      it "should list components" do
        stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components.json", "components.json"
        components = @client.list_components(123)
        components.first.allocated_quantity.should == 42
        components.last.allocated_quantity.should == 2
      end

      it "should show a specific component" do
        stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/16.json", "component.json"
        component = @client.subscription_component 123, 16
        component.name.should == "Extra Rubies"
        component.allocated_quantity.should == 42
      end

      it "should update the allocated_quantity for a component" do
        stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123/components/16.json", "component.json"
        response = @client.update_subscription_component_allocated_quantity 123, 16, 20_000_000
        response.success?.should == true
      end
    end

  end
end
