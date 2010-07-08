module Chargify
  class Client
    include HTTParty

    parser Chargify::Parser
    headers 'Content-Type' => 'application/json'

    attr_reader :api_key, :subdomain

    # Your API key can be generated on the settings screen.
    def initialize(options={})
      @api_key = options[:api_key] ? options[:api_key] : Chargify::Config.api_key
      @subdomain = options[:subdomain] ? options[:subdomain] : Chargify::Config.subdomain

      self.class.base_uri "https://#{@subdomain}.chargify.com"
      self.class.basic_auth @api_key, 'x'
    end



    def customer_subscriptions(chargify_id)
      subscriptions = get("/customers/#{chargify_id}/subscriptions.json")
      subscriptions.map{|s| Hashie::Mash.new s['subscription']}
    end



    def migrate_subscription(sub_id, product_id)
      raw_response = post("/subscriptions/#{sub_id}/migrations.json", :body => {:product_id => product_id })
      success      = true if raw_response.code == 200
      response     = Hashie::Mash.new(raw_response)
      (response.subscription || {}).update(:success? => success)
    end

    def list_products
      products = get("/products.json")
      products.map{|p| Hashie::Mash.new p['product']}
    end

    def product(product_id)
      Hashie::Mash.new( get("/products/#{product_id}.json")).product
    end

    def product_by_handle(handle)
      Hashie::Mash.new(get("/products/handle/#{handle}.json")).product
    end

    def list_subscription_usage(subscription_id, component_id)
      raw_response = get("/subscriptions/#{subscription_id}/components/#{component_id}/usages.json")
      success      = raw_response.code == 200
      response     = Hashie::Mash.new(raw_response)
      response.update(:success? => success)
    end

    def subscription_transactions(sub_id, options={})
      transactions = get("/subscriptions/#{sub_id}/transactions.json", :query => options)
      transactions.map{|t| Hashie::Mash.new t['transaction']}
    end

    def site_transactions(options={})
      transactions = get("/transactions.json", :query => options)
      transactions.map{|t| Hashie::Mash.new t['transaction']}
    end

    def list_components(subscription_id)
      components = get("/subscriptions/#{subscription_id}/components.json")
      components.map{|c| Hashie::Mash.new c['component']}
    end

    def subscription_component(subscription_id, component_id)
      response = get("/subscriptions/#{subscription_id}/components/#{component_id}.json")
      Hashie::Mash.new(response).component
    end

    def update_subscription_component_allocated_quantity(subscription_id, component_id, quantity)
      response = put("/subscriptions/#{subscription_id}/components/#{component_id}.json", :body => {:component => {:allocated_quantity => quantity}})
      response[:success?] = response.code == 200
      Hashie::Mash.new(response)
    end

    private

      def post(path, options={})
        jsonify_body!(options)
        self.class.post(path, options)
      end

      def put(path, options={})
        jsonify_body!(options)
        self.class.put(path, options)
      end

      def delete(path, options={})
        jsonify_body!(options)
        self.class.delete(path, options)
      end

      def get(path, options={})
        jsonify_body!(options)
        self.class.get(path, options)
      end

      def jsonify_body!(options)
        options[:body] = options[:body].to_json if options[:body]

      end
  end
end
