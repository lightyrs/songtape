class User < ActiveRecord::Base

  attr_accessible :name

  validates_presence_of :name

  has_many :identities, :dependent => :destroy

  def avatar
    identities.all(:order => "logged_in_at desc", :limit => 1).first.avatar
  end
end