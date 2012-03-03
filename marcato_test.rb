require 'rubygems'
require "#{File.dirname(__FILE__)}/marcato"
require 'minitest/autorun'
require 'mocha'

class MarcatoTest < MiniTest::Unit::TestCase
  def setup
    @m = Marcato.new
  end

  def test_randomize
    refute(@m.instance_variable_get(:@random))
    @m.randomize!
    assert(@m.instance_variable_get(:@random))
  end
end
