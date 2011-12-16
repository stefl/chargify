module Chargify
  class Parser < HTTParty::Parser

    def parse
      begin
        JSON.parse(body)
      rescue => e
        raise(Chargify::Error::UnexpectedResponse.new(e.message), body)
      end
    end

  end
end
