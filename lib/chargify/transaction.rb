module Chargify
  class Transaction < Base

    class << self

      def all(options={})
        result = api_request(:get, "/transactions.json", :query => options)
        result.map{|t| Hashie::Mash.new t['transaction']}
      end

    end

  end
end
