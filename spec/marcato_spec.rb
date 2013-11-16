require File.expand_path("#{File.dirname(__FILE__)}/../lib/marcato")
require 'minitest/spec'
require 'minitest/autorun'
require 'mocha/setup'

describe Marcato do
  before(:each) do
    @m = Marcato.new
  end

  it 'should randomize' do
    @m.instance_variable_get(:@random).must_be_nil
    @m.randomize!
    @m.instance_variable_get(:@random).wont_be_nil
  end
end
