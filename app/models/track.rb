class Track < ActiveRecord::Base

  attr_accessible :title, :album_name, :artist_name, :embed_url, :short_url

  validates_presence_of   :title
  validates_presence_of   :artist_name

  validates_uniqueness_of :title, :scope => :artist_name
end