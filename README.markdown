# chargify

Ruby wrapper for the chargify.com SAAS and billing API

### Important Notice

This fork breaks all compatibility with previous versions (<= 0.2.6)

## Installation

    gem install chargify
    
## Example Usage

### Create, cancel, then reactivate subscription
    attributes   = { :product_handle => 'basic' ... }
    subscription = Chargify::Subscription.create(attributes)
    Chargify::Subscription.cancel(subscription[:id], "Canceled due to bad customer service.") 
    Chargify::Subscription.reactivate(subscription[:id]) #Made him an offer he couldn't refuse!

## Rails Usage

### config/initializers/chargify.rb
    Chargify::Config.setup do |config|
      config[:subdomain] = 'xxx-test'
      config[:api_key]   = 'InDhcXAAAAAg7juDD'
    end

## Contributing (requires Bundler >= 0.9.7):

    $ git clone git://github.com/jsmestad/chargify.git
    $ cd chargify
    $ bundle install
    $ bundle exec rake

### Copyright

See LICENSE for details.
