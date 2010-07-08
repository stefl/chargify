require 'spec_helper'

describe Chargify do
  context "Chargify API client" do

    before do
      @client = Chargify::Client.new(:api_key => 'OU812', :subdomain => 'pengwynn')
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
