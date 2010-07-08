require 'spec_helper'

describe Chargify::Parser do
  subject { Chargify::Parser.send(:new, 'body', :json) }

  it { should respond_to(:parse) }
end
