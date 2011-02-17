# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stefl-chargify}
  s.version = "0.3.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Wynn Netherland", "Justin Smestad"]
  s.date = %q{2011-02-17}
  s.email = %q{justin.smestad@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "changelog.md",
    "lib/chargify.rb",
    "lib/chargify/base.rb",
    "lib/chargify/config.rb",
    "lib/chargify/customer.rb",
    "lib/chargify/error.rb",
    "lib/chargify/parser.rb",
    "lib/chargify/product.rb",
    "lib/chargify/product_family.rb",
    "lib/chargify/subscription.rb",
    "lib/chargify/transaction.rb",
    "spec/fixtures/charge_subscription.json",
    "spec/fixtures/charge_subscription_missing_parameters.json",
    "spec/fixtures/component.json",
    "spec/fixtures/components.json",
    "spec/fixtures/customer.json",
    "spec/fixtures/customers.json",
    "spec/fixtures/deleted_subscription.json",
    "spec/fixtures/invalid_subscription.json",
    "spec/fixtures/list_metered_subscriptions.json",
    "spec/fixtures/migrate_subscription.json",
    "spec/fixtures/new_customer.json",
    "spec/fixtures/product.json",
    "spec/fixtures/products.json",
    "spec/fixtures/subscription.json",
    "spec/fixtures/subscription_not_found.json",
    "spec/fixtures/subscriptions.json",
    "spec/spec_helper.rb",
    "spec/support/fakeweb_stubs.rb",
    "spec/unit/chargify/config_spec.rb",
    "spec/unit/chargify/customer_spec.rb",
    "spec/unit/chargify/parser_spec.rb",
    "spec/unit/chargify/product_spec.rb",
    "spec/unit/chargify/subscription_spec.rb",
    "spec/unit/chargify/transaction_spec.rb",
    "stefl-chargify.gemspec"
  ]
  s.homepage = %q{http://github.com/stefl/chargify}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Ruby wrapper for the Chargify API}
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/support/fakeweb_stubs.rb",
    "spec/unit/chargify/config_spec.rb",
    "spec/unit/chargify/customer_spec.rb",
    "spec/unit/chargify/parser_spec.rb",
    "spec/unit/chargify/product_spec.rb",
    "spec/unit/chargify/subscription_spec.rb",
    "spec/unit/chargify/transaction_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httparty>, [">= 0.6.1"])
      s.add_runtime_dependency(%q<hashie>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
    else
      s.add_dependency(%q<httparty>, [">= 0.6.1"])
      s.add_dependency(%q<hashie>, [">= 0.4.0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 3.0.0"])
      s.add_dependency(%q<i18n>, [">= 0"])
    end
  else
    s.add_dependency(%q<httparty>, [">= 0.6.1"])
    s.add_dependency(%q<hashie>, [">= 0.4.0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 3.0.0"])
    s.add_dependency(%q<i18n>, [">= 0"])
  end
end

