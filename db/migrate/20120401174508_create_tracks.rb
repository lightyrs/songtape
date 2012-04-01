class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string   :title
      t.string   :artist_name
      t.integer  :artist_id
      t.string   :album_name
      t.integer  :album_id
      t.string   :short_url
      t.string   :embed_url

      t.timestamps
    end
    add_index :tracks, [:title, :artist_name], :unique => true
  end
end
