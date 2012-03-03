require 'rubygems'
require 'yaml'

class Marcato
  VERSION = '0.0.2'
  MARCATO_FILE = ENV['MARCATO_FILE'] || "#{ENV['HOME']}/.marcato"
  MARCATO_MUSIC = File.expand_path(ENV['MARCATO_MUSIC'] || '.')
  EDITOR = ENV['EDITOR'] || 'vi'

  def randomize!
    @random = true
  end

  def edit
    `#{EDITOR} #{MARCATO_FILE} < \`tty\` > \`tty\``
  end

  def list
    puts playlists.keys.sort.join("\n") if !playlists.empty?
  end

  def play(query = '')
    searches = query.split(/\s+/)
    searches = [''] if searches.empty?
    playlists.select { |k,v| searches.include?(k) }.each do |name, terms|
      searches += terms
    end
    files = searches.map do |search|
      Dir.glob(File.join(MARCATO_MUSIC, "**/*#{search}*"))
    end.flatten.uniq
    files = @random ? files.sort_by { rand } : files.sort
    puts files.join("\n") if !files.empty?
  end

  private
  def playlists
    YAML.load(File.read(MARCATO_FILE))
  end
end
