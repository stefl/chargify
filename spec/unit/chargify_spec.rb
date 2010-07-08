require 'spec_helper'

describe Chargify do
  context "Chargify API client" do

    before do
      @client = Chargify::Client.new(:api_key => 'OU812', :subdomain => 'pengwynn')
    end



    context "for metered subscriptions" do



    end


  end
end
