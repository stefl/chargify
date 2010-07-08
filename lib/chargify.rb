require 'hashie'
require 'httparty'
require 'json'

Hash.send :include, Hashie::HashExtensions

module Chargify
  VERSION = "0.2.6".freeze

  autoload :Base,         'chargify/base'
  autoload :Client,       'chargify/client'
  autoload :Config,       'chargify/config'
  autoload :Customer,     'chargify/customer'
  autoload :Error,        'chargify/error'
  autoload :Parser,       'chargify/parser'
  autoload :Subscription, 'chargify/subscription'

  class UnexpectedResponseError < RuntimeError; end

end
