require 'hashie'
require 'httparty'
require 'json'

Hash.send :include, Hashie::HashExtensions

module Chargify
  VERSION = "0.2.6".freeze

  autoload :Client, 'chargify/client'
  autoload :Config, 'chargify/config'

  class UnexpectedResponseError < RuntimeError; end

end
