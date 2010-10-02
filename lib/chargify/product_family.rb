module Chargify
  class ProductFamily < Base
    class << self

      def find!(id)
        return all if id == :all

        result = api_request(:get, "/product_families/#{id}.json")
        Hashie::Mash.new(result).product
      end
      
      def find(id)
        find!(id)
      rescue Chargify::Error::Base => e
        return nil
      end
      
      def find_by_handle(handle)
        find_by_handle!(handle)
      rescue Chargify::Error::Base => e
        return nil
      end

      def find_by_handle!(handle)
        result = api_request(:get, "/product_families/lookup.json?reference=#{handle}")
        Hashie::Mash.new(result).product
      end

    end
  end
end
