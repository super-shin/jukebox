require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "sqlite3"

set :views, File.join(File.dirname(__FILE__), "/views")

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), "db/jukebox.sqlite"))

get "/" do
  @artists = DB.execute('SELECT * FROM artists')
  # puts "@artists: #{@artists.inspect}"
  erb :home # Will render views/home.erb file (embedded in layout.erb)
end

# Then:
get "/artists/:id" do
  @artist = DB.execute('SELECT * FROM artists WHERE id = ?', params[:id]).first
  @albums = DB.execute('SELECT * FROM albums WHERE artist_id = ?', params[:id])
  # puts "@artist: #{@artist.inspect}"
  # puts "@albums: #{@albums.inspect}"
  erb :artist
end

get "/albums/:id" do
  @album = DB.execute('SELECT * FROM albums WHERE id = ?', params[:id]).first
  @tracks = DB.execute('SELECT * FROM tracks WHERE album_id = ?', params[:id])
  # puts "@album: #{@album.inspect}"
  # puts "@tracks: #{@tracks.inspect}"
  erb :album
end

get "/tracks/:id" do
  @track = DB.execute('SELECT * FROM tracks WHERE id = ?', params[:id]).first
  puts "@track: #{@track.inspect}"
  erb :track
end
# 1. Create an artist page with all the albums. Display genres as well
# 2. Create an album pages with all the tracks
# 3. Create a track page with all the track info
