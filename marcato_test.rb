require 'rubygems'
require "#{File.dirname(__FILE__)}/marcato"
require 'minitest/autorun'
require 'mocha'

class MarcatoTest < MiniTest::Unit::TestCase
  def setup
    @library = {
      'tracks' => {
        '1' => {'id' => '1', 'name' => 'FirstSong', 'artist' => 'Nameless', 'file' => '/first-song.mp3'},
        '2' => {'id' => '2', 'name' => 'Second Song', 'artist' => 'Squirtles', 'file' => '/second-song.mp3'},
        '3' => {'id' => '3', 'name' => 'Third Song', 'artist' => 'Squirtles', 'file' => '/third-song.mp3'}
      },
      'playlists' => {
        '1' => {'id' => '1', 'tracks' => %w(1 2 3), 'name' => 'Library'},
        '2' => {'id' => '2', 'tracks' => %w(2 3), 'name' => 'Squirtles'}
      }
    }
    @ps_and_grep = 
      "hbien 100 0.8 0.1 2473 840 ?? S 9:53PM 0:00.85 afplay /sample.mp3\n" +
      "hbien 101 0.0 0.2 2469 680 ?? S 9:14PM 0:00.07 ./marcato --init /sample.mp3\n" +
      "hbien 102 0.0 0.0 2430 400 s004 R+ 9:54PM 0:00.00 grep -e marcato --init\|afplay\n"
    @m = Marcato.new
    @m.stubs(:library => @library, :ps_and_grep => @ps_and_grep)
  end

  def test_ps_for
    ps = @m.send(:ps_for, 'sample-term')
    assert_equal(2, ps.size)
    assert_equal(100, ps[0][:pid])
    assert_equal('S', ps[0][:status])
    assert_equal(101, ps[1][:pid])
    assert_equal('S', ps[1][:status])
  end

  def test_prefix
    assert_equal('1.', @m.send(:prefix, 0, 1))
    assert_equal(' 2.', @m.send(:prefix, 1, 10))
    assert_equal(' 10.', @m.send(:prefix, 9, 100))
    assert_equal('101.', @m.send(:prefix, 100, 1))
  end

  def test_parse_library
    lib = @m.send(:parse_library,
      File.read("#{File.dirname(__FILE__)}/sample.xml"))

    assert(lib['tracks'])
    refute(lib['tracks'].any? {|id,track| track['id'] != id || id.to_i == 0})
    refute(lib['tracks'].values.any? {|t| t['name'].to_s == ''})
    refute(lib['tracks'].values.any? {|t| t['file'].to_s == ''})
    refute(lib['tracks'].values.any? {|t| !t.has_key?('artist')})

    assert(lib['playlists'])
    refute(lib['playlists'].any? {|id,list| list['id'] != id || id.to_i == 0})
    refute(lib['playlists'].values.any? {|l| l['name'].to_s == ''})

    lib['playlists'].values.each do |list|
      refute(list['tracks'].size == 0, "#{list['name']} missing tracks")
    end
  end
end
