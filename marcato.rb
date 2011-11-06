require 'rubygems'
require 'plist'
require 'cgi'
require 'json'

class Marcato
  VERSION = '0.0.1'
  ITUNES_LIBRARY = ENV['MARCATO_ITUNES'] || "#{ENV['HOME']}/Music/iTunes/iTunes Music Library.xml"
  MARCATO_LIBRARY = ENV['MARCATO_FILE'] || "#{ENV['HOME']}/.marcatodb"

  class << self; attr_accessor :rewind; end

  def randomize!
    @random = true
  end

  def repeat!
    @repeat = true
  end

  def sync
    lib = parse_library(File.read(ITUNES_LIBRARY))
    File.open(MARCATO_LIBRARY, 'w') do |file|
      file.puts(JSON.pretty_generate(lib))
    end
  end

  def play(query = '')
    items = if query !~ /^\s*$/
      playlists = library['playlists'].values.select {|p| p['name'] =~ /#{query}/i}
      tracks = library['tracks'].values.select do |t| 
        t['name'] =~ /#{query}/i || t['artist'] =~ /#{query}/i
      end
      playlists.sort_by {|p| p['name']} + 
      tracks.sort_by {|t| "#{t['artist']} - #{t['name']}"}
    else
      library['playlists'].values.sort_by {|p| p['name']}
    end
    if items.size > 1
      items.each_with_index do |item, index|
        if item['tracks']
          puts "#{prefix(index, items.size)} Playlist - #{item['name']}"
        else
          puts "#{prefix(index, items.size)} #{item['artist'] || 'Artist Unknown'} - #{item['name']}"
        end
      end
      print '> '
      input = $stdin.gets
      if input.to_s =~ /^\d+$/
        items = input.to_i > 0 && input.to_i <= items.size ? [items[input.to_i - 1]] : []
      elsif input.nil? || input.strip != ''
        items = []
      end
    end
    if items.size > 0
      stop
      filenames = []
      items.each do |item|
        if item['tracks']
          item['tracks'].each do |track_id|
            track = library['tracks'][track_id]
            filenames << track['file'] if !track.nil?
          end.compact
        else
          filenames << item['file']
        end
      end
      filenames.select! { |f| File.exists?(f) }
      system("marcato #{'--random ' if @random}#{'--repeat ' if @repeat}--init #{filenames.map {|f| "\"#{f}\""}.join(' ')} &")
    end
  end

  def pause
    pses = ps_for('marcato .*--init\|afplay')
    pses.each do |ps|
      Process.kill(pses.first[:status] == 'T' ? 'CONT' : 'STOP', ps[:pid])
    end
  end

  def stop
    ps_for('marcato .*--init\|afplay').each do |ps|
      Process.kill(9, ps[:pid])
    end
  end

  def skip_forward
    ps_for('afplay').each do |ps|
      Process.kill(9, ps[:pid])
    end
  end

  def skip_backward
    ps_for('marcato .*--init').each do |ps|
      Process.kill(16, ps[:pid])
    end
  end

  def init_player(songs)
    while true
      songs = songs.sort_by { rand } if @random
      index = 0
      while index < songs.size
        `afplay "#{songs[index]}"` if File.exists?(songs[index])
        index += (Marcato.rewind ? -1 : 1)
        Marcato.rewind = false
      end
      break if !@repeat
    end
  end
  # Hack to handle rewind
  Signal.trap(16) { Marcato.rewind = true; `killall afplay` }

  private
  def ps_for(term)
    ps_and_grep(term).
      split("\n").
      reject { |line| line.split(/\s+/)[10..-1].join(' ') =~ /(^| )grep / }.
      map { |line| vals = line.split(/\s+/); {:pid => vals[1].to_i, :status => vals[7]} }
  end

  def ps_and_grep(term) # for stubbing in tests
    `ps aux | grep -e "#{term}"`
  end

  def prefix(index, size)
    index = index + 1
    spaces = [0, size.to_s.length - index.to_s.length].max
    "#{' ' * spaces}#{index}."
  end

  def library
    @library ||= JSON.parse(File.read(MARCATO_LIBRARY))
  end

  def parse_library(xml)
    doc = Plist::parse_xml(xml)
    lib = {'tracks' => {}, 'playlists' => {}}
    doc['Tracks'].each do |track_id, track|
      next if track['Location'].nil? ||
              track['Location'] !~ /^file:\/\/localhost/ ||
              track['Location'] !~ /\.(mp3|m4a)$/ ||
              track_id.nil?
      lib['tracks'][track_id.to_s] = {
        'id' => track_id.to_s,
        'name' => track['Name'].to_s.strip,
        'artist' => track['Artist'].to_s.strip,
        'file' => CGI::unescape(track['Location'].sub('file://localhost', ''))
      }
    end
    doc['Playlists'].each do |playlist|
      playlist_id = playlist['Playlist ID'].to_s
      track_ids = (playlist['Playlist Items'] || []).
        map { |i| i['Track ID'].to_s }.
        reject { |id| id == 0 }
      if playlist_id != 0 && playlist['Name'] && track_ids.size > 0
        lib['playlists'][playlist_id] = {
          'id' => playlist_id,
          'tracks' => track_ids,
          'name' => playlist['Name'].to_s.strip
        }
      end
    end
    lib
  end
end
