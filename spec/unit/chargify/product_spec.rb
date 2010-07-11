require 'spec_helper'

describe Chargify::Product do

  describe '.all' do

    it "should return a list of products" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products.json", "products.json"
      products = Chargify::Product.all
      products.first.accounting_code.should == 'TSMO'
    end

  end

  describe '.find' do

    it "should return info for a product" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/8.json", "product.json"
      product = Chargify::Product.find(8)
      product.accounting_code.should == 'TSMO'
    end
    
    it "should return nil if the product does not exist for a product" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/99.json", "", 404
      Chargify::Product.find(99).should == nil
    end

  end

  describe '.find_by_handle' do

    it "should return info for a product by its handle" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/handle/tweetsaver.json", "product.json"
      product = Chargify::Product.find_by_handle('tweetsaver')
      product.accounting_code.should == 'TSMO'
    end

  end

end
