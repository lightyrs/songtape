class Rdio

  include ActiveAttr::Model

  attr_accessor :client

  def initialize
    @key = configatron.rdio.key
    @secret = configatron.rdio.secret
    @client = init_client
  end

  def init_client
    RdioApi.new(:consumer_key => @key, :consumer_secret => @secret)
  end

  def tracks_in_collection(user_id=nil)
    if user_id.present?
      client.getTracksInCollection(:user => user_id, :count => 1000, :sort => "playCount").map do |t|
        Track.new(:title => t.name, :album_name => t.album, :artist_name => t.artist, :embed_url => t.embedUrl,
                  :short_url => t.shortUrl)
      end
    else
      "You must provide a valid Rdio User ID.".red_on_white
    end
  end
end