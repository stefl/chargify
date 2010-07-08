module Chargify
  class Client < Base

    def list_subscription_usage(subscription_id, component_id)
      result = api_request(:get, "/subscriptions/#{subscription_id}/components/#{component_id}/usages.json")
      success      = result.code == 200
      response     = Hashie::Mash.new(result)
      response.update(:success? => success)
    end

  end
end
