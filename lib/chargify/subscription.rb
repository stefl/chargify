module Chargify
  class Subscription < Base

    class << self

      def find!(id)
        result = api_request(:get, "/subscriptions/#{id}.json")
        Hashie::Mash.new(result).subscription
      end
      
      def find(id)
        find!(id)
      rescue Chargify::Error::Base => e
        return nil
      end

      def create!(subscription_attributes={})
        result = api_request(:post, "/subscriptions.json", :body => {:subscription => subscription_attributes})
        response = Hashie::Mash.new(result)
        response.subscription
      end
      
      def create(subscription_attributes={})
        create!(subscription_attributes)
      rescue Chargify::Error::Base => e
        return false
      end

      def update!(sub_id, subscription_attributes = {})
        result = api_request(:put, "/subscriptions/#{sub_id}.json", :body => {:subscription => subscription_attributes})
        response = Hashie::Mash.new(result)
        response.subscription
      end
      
      def update(sub_id, subscription_attributes = {})
        update!(subscription_attributes)
      rescue Chargify::Error::Base => e
        return false
      end

      def cancel!(sub_id, message="")
        result = api_request(:delete, "/subscriptions/#{sub_id}.json", :body => {:subscription => {:cancellation_message => message} })
        true if result.code == 200
      end
      
      def cancel(sub_id, message="")
        cancel!(sub_id, message)
      rescue Chargify::Error::Base => e
        return false
      end

      def reactivate!(sub_id)
        result = api_request(:put, "/subscriptions/#{sub_id}/reactivate.json", :body => "")
        response = Hashie::Mash.new(result)
        response.subscription
      end
      
      def reactivate(sub_id)
        reactivate!(sub_id)
      rescue Chargify::Error::Base => e
        return false
      end

      def charge!(sub_id, subscription_attributes={})
        result = api_request(:post, "/subscriptions/#{sub_id}/charges.json", :body => { :charge => subscription_attributes })
        response = Hashie::Mash.new(result)
        response.charge
      end
      
      def charge(sub_id, subscription_attributes={})
        charge!(sub_id, subscription_attributes)
      rescue Chargify::Error::Base => e
        return false
      end

      def migrate!(sub_id, product_id)
        result = api_request(:post, "/subscriptions/#{sub_id}/migrations.json", :body => {:product_id => product_id })
        response = Hashie::Mash.new(result)
        response.subscription
      end
      
      def migrate(sub_id, product_id)
        migrate!(sub_id, product_id)
      rescue Chargify::Error::Base => e
        return false
      end

      def transactions!(sub_id, options={})
        result = api_request(:get, "/subscriptions/#{sub_id}/transactions.json", :query => options)
        result.map{|t| Hashie::Mash.new t['transaction']}
      end
      
      def transactions(sub_id, options={})
        transactions!(sub_id, options)
      rescue Chargify::Error::Base => e
        return false
      end

      def components!(subscription_id)
        result = api_request(:get, "/subscriptions/#{subscription_id}/components.json")
        result.map{|c| Hashie::Mash.new c['component']}
      end
      
      def components(subscription_id)
        components!(subscription_id)
      rescue Chargify::Error::Base => e
        return false
      end

      def find_component!(subscription_id, component_id)
        result = api_request(:get, "/subscriptions/#{subscription_id}/components/#{component_id}.json")
        Hashie::Mash.new(result).component
      end
      
      def find_component(subscription_id, component_id)
        find_component!(subscription_id, component_id)
      rescue Chargify::Error::Base => e
        return false
      end

      def update_component!(subscription_id, component_id, quantity)
        result = api_request(:put, "/subscriptions/#{subscription_id}/components/#{component_id}.json", :body => {:component => {:allocated_quantity => quantity}})
        Hashie::Mash.new(result)
      end
      
      def update_component(subscription_id, component_id, quantity)
        update_component!(subscription_id, component_id, quantity)
      rescue Chargify::Error::Base => e
        return false
      end

      def component_usage!(subscription_id, component_id)
        result = api_request(:get, "/subscriptions/#{subscription_id}/components/#{component_id}/usages.json")
        response = Hashie::Mash.new(result)
        response
      end
      
      def component_usage(subscription_id, component_id)
        component_usage!(subscription_id, component_id)
      rescue Chargify::Error::Base => e
        return false
      end

    end

  end
end
