module Chargify
  class Subscription < Base

    class << self

      def find(id)
        result = api_request(:get, "/subscriptions/#{id}.json")
        return nil if result.code != 200
        Hashie::Mash.new(result).subscription
      end

      # Returns all elements outputted by Chargify plus:
      # response.success? -> true if response code is 201, false otherwise
      def create(subscription_attributes={})
        result = api_request(:post, "/subscriptions.json", :body => {:subscription => subscription_attributes})
        created  = true if result.code == 201
        response = Hashie::Mash.new(result)
        (response.subscription || response).update(:success? => created)
      end

      # Returns all elements outputted by Chargify plus:
      # response.success? -> true if response code is 200, false otherwise
      def update(sub_id, subscription_attributes = {})
        result = api_request(:put, "/subscriptions/#{sub_id}.json", :body => {:subscription => subscription_attributes})
        updated = true if result.code == 200
        response = Hashie::Mash.new(result)
        (response.subscription || response).update(:success? => updated)
      end

      # Returns all elements outputted by Chargify plus:
      # response.success? -> true if response code is 200, false otherwise
      def cancel(sub_id, message="")
        result = api_request(:delete, "/subscriptions/#{sub_id}.json", :body => {:subscription => {:cancellation_message => message} })
        deleted = true if result.code == 200
        response = Hashie::Mash.new(result)
        (response.subscription || response).update(:success? => deleted)
      end

      def reactivate(sub_id)
        result = api_request(:put, "/subscriptions/#{sub_id}/reactivate.json", :body => "")
        reactivated  = true if result.code == 200
        response = Hashie::Mash.new(result) rescue Hashie::Mash.new
        (response.subscription || response).update(:success? => reactivated)
      end

      def charge(sub_id, subscription_attributes={})
        result = api_request(:post, "/subscriptions/#{sub_id}/charges.json", :body => { :charge => subscription_attributes })
        success = result.code == 201
        result = {} if result.code == 404

        response = Hashie::Mash.new(result)
        (response.charge || response).update(:success? => success)
      end

      def migrate(sub_id, product_id)
        result = api_request(:post, "/subscriptions/#{sub_id}/migrations.json", :body => {:product_id => product_id })
        success = true if result.code == 200
        response = Hashie::Mash.new(result)
        (response.subscription || {}).update(:success? => success)
      end

      def transactions(sub_id, options={})
        result = api_request(:get, "/subscriptions/#{sub_id}/transactions.json", :query => options)
        result.map{|t| Hashie::Mash.new t['transaction']}
      end

      def components(subscription_id)
        result = api_request(:get, "/subscriptions/#{subscription_id}/components.json")
        result.map{|c| Hashie::Mash.new c['component']}
      end

      def find_component(subscription_id, component_id)
        result = get("/subscriptions/#{subscription_id}/components/#{component_id}.json")
        Hashie::Mash.new(result).component
      end

      def update_component(subscription_id, component_id, quantity)
        result = api_request(:put, "/subscriptions/#{subscription_id}/components/#{component_id}.json", :body => {:component => {:allocated_quantity => quantity}})
        result[:success?] = result.code == 200
        Hashie::Mash.new(result)
      end

      def component_usage(subscription_id, component_id)
        result = api_request(:get, "/subscriptions/#{subscription_id}/components/#{component_id}/usages.json")
        success = result.code == 200
        response = Hashie::Mash.new(result)
        response.update(:success? => success)
      end

    end

  end
end
