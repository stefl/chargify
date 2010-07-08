require 'hashie'
require 'httparty'
require 'json'

Hash.send :include, Hashie::HashExtensions

module Chargify
  VERSION = "0.2.6".freeze

  autoload :Client, 'chargify/client'
  autoload :Config, 'chargify/config'
  autoload :Parser, 'chargify/parser'

  class UnexpectedResponseError < RuntimeError; end

end
