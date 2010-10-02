module Chargify
  class ProductFamily < Base
    class << self

      def all
        result = api_request(:get, "/product_families.json")
        result.map {|p| Hashie::Mash.new p['product_family']}
      end

      def find!(id)
        return all if id == :all

        result = api_request(:get, "/product_families/#{id}.json")
        Hashie::Mash.new(result).product_family
      end

      def find(id)
        find!(id)
      rescue Chargify::Error::Base => e
        return nil
      end

      def find_by_handle!(handle)
        result = api_request(:get, "/product_families/lookup.json?handle=#{handle}")
        Hashie::Mash.new(result).product_family
      end

      def find_by_handle(handle)
        find_by_handle!(handle)
      rescue Chargify::Error::Base => e
        return nil
      end

      def components!(product_family_id)
        result = api_request(:get, "/product_families/#{product_family_id}/components.json")
        result.map {|p| Hashie::Mash.new p['component']}
      end

      def components(product_family_id)
        components!(product_family_id)
      rescue Chargify::Error::Base => e
        return nil
      end

    end
  end
end
