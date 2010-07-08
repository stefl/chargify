module Chargify
  class Base
    include HTTParty

    parser Chargify::Parser
    format :json
    headers 'Content-Type' => 'application/json'
    headers 'User-Agent' => 'Chargify Ruby Client'

    class << self

      def api_request(type, path, options={})
        self.base_uri "https://#{Chargify::Config.subdomain}.chargify.com"
        self.basic_auth Chargify::Config.api_key, 'x'

        # This is to allow bang methods
        raise_errors = options.delete(:raise_errors)

        begin
          response = self.send(type.to_s, path, options)
        rescue SocketError
          raise(Chargify::Error::ConnectionFailed.new, "Failed to connect to payment gateway.")
        end

        if raise_errors
          case response.code.to_i
          when 401
            raise(Chargify::Error::AccessDenied.new(response), response.body)
          when 403
            raise(Chargify::Error::Forbidden.new(response), response.body)
          when 422
            raise(Chargify::Error::BadRequest.new(response), response.body)
          when 404
            raise(Chargify::Error::NotFound.new(response), response.body)
          when 504
            raise(Chargify::Error::GatewayTimeout.new(response), response.body)
          end
        end

        response
      end

    end

    attr_reader :errors

    def initialize(options={})
      Chargify::Config.api_key = options[:api_key] if options[:api_key]
      Chargify::Config.subdomain = options[:subdomain] if options[:subdomain]



      @errors = []
      self.attributes = attrs

    end

    def attributes=(attrs)
      attrs.each do |k, v|
        self.send(:"#{k}=", v) if self.respond_to?(:"#{k}=")
      end
    end

    def api_request(type, path, options={})
      @errors = []
      begin
        self.class.api_request(type, path, options)
      rescue Chargify::Error::Base => e
        if e.response.is_a?(Hash)
          if e.response.has_key?("errors")
            @errors = [*e.response["errors"]["error"]]
          else
            @errors = [e.response.body]
          end
        else
          @errors = [e.message]
        end
        raise
      end
    end

  end
end

