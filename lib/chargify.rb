require 'hashie'
require 'httparty'
require 'json'
require 'active_support/core_ext/hash'

Hash.send :include, Hashie::HashExtensions

module Chargify

  autoload :Base,         'chargify/base'
  autoload :Config,       'chargify/config'
  autoload :Customer,     'chargify/customer'
  autoload :Error,        'chargify/error'
  autoload :Parser,       'chargify/parser'
  autoload :Product,      'chargify/product'
  autoload :Subscription, 'chargify/subscription'
  autoload :Transaction,  'chargify/transaction'

  # TODO: migrate away from generic errors
  # Replace with Chargify::Errors


end
