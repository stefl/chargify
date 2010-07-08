module Chargify
  class Customer < Base

    class << self

      # options: page
      def all(options={})
        customers = api_request(:get, '/customers.json', :query => options)
        customers.map{|c| Hashie::Mash.new c['customer']}
      end

      def find(id)
        return all if id == :all

        request = api_request(:get, "/customers/#{id}.json")
        success = request.code == 200
        response = Hashie::Mash.new(request).customer if success
        Hashie::Mash.new(response || {}).update(:success? => success)
      end

      # def find!(id)
        # request = api_request(:get, "/customers/#{id}.json", :raise_errors => true)
        # response = Hashie::Mash.new(request).customer
      # end

      def lookup(reference_id)
        request = api_request(:get, "/customers/lookup.json?reference=#{reference_id}")
        success = request.code == 200
        response = Hashie::Mash.new(request).customer if success
        Hashie::Mash.new(response || {}).update(:success? => success)
      end

      #
      # * first_name (Required)
      # * last_name (Required)
      # * email (Required)
      # * organization (Optional) Company/Organization name
      # * reference (Optional, but encouraged) The unique identifier used within your own application for this customer
      #
      def create(info={})
        result = api_request(:post, "/customers.json", :body => {:customer => info})
        response = Hashie::Mash.new(result)
        return response.customer if response.customer
        response
      end

      #
      # * first_name (Required)
      # * last_name (Required)
      # * email (Required)
      # * organization (Optional) Company/Organization name
      # * reference (Optional, but encouraged) The unique identifier used within your own application for this customer
      #
      def update(info={})
        info.stringify_keys!
        chargify_id = info.delete('id')
        result = api_request(:put, "/customers/#{chargify_id}.json", :body => {:customer => info})

        response = Hashie::Mash.new(result)
        return response.customer unless response.customer.to_a.empty?
        response
      end

      def subscriptions(id)
        subscriptions = api_request(:get, "/customers/#{id}/subscriptions.json")
        subscriptions.map{|s| Hashie::Mash.new s['subscription']}
      end

    end

  end
end
