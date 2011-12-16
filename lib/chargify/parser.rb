require 'crack'

module Chargify
  class Parser < HTTParty::Parser

    def parse
      begin
        ::Crack::JSON.parse(body)
      rescue => e
        raise(Chargify::Error::UnexpectedResponse.new(e.message), body)
      end
    end

  end
end
