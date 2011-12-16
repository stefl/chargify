module Chargify
  class Parser < HTTParty::Parser

    def parse
      begin
        puts body
        Crack::JSON.parse(body)
      rescue => e
        puts e.message
        raise(Chargify::Error::UnexpectedResponse.new(e.message), body)
      end
    end

  end
end
