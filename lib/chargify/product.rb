module Chargify
  class Product < Base

    class << self

      def all
        result = api_request(:get, "/products.json")
        result.map{|p| Hashie::Mash.new p['product']}
      end

      def find(id)
        return all if id == :all

        result = api_request(:get, "/products/#{id}.json")
        Hashie::Mash.new(result).product
      end

      def find_by_handle(handle)
        result = api_request(:get, "/products/handle/#{handle}.json")
        Hashie::Mash.new(result).product
      end

    end

  end
end
