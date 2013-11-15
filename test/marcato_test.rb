require File.expand_path("#{File.dirname(__FILE__)}/../lib/marcato")
gem 'minitest'
require 'minitest/autorun'
require 'mocha/setup'

class MarcatoTest < Minitest::Test
  def setup
    @m = Marcato.new
  end

  def test_randomize
    refute(@m.instance_variable_get(:@random))
    @m.randomize!
    assert(@m.instance_variable_get(:@random))
  end
end
