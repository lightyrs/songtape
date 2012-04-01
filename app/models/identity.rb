class Identity < ActiveRecord::Base

  belongs_to :user

  validates :provider, :presence => true
  validates :uid, :uniqueness => { :scope => :provider }, :presence => true

  attr_accessor :auth
  attr_accessible :auth, :uid, :provider, :login_count, :logged_in_at


  class << self

    def find_or_create_with_omniauth(auth)
      if identity = Identity.find_with_omniauth(auth)
        identity.refresh_provider_data(auth)
      else
        identity = Identity.create_with_omniauth(auth)
      end

      identity
    end

    def find_with_omniauth(auth)
      find_by_provider_and_uid(auth['provider'], auth['uid'])
    end

    def create_with_omniauth(auth)
      identity = Identity.new(auth: auth, uid: auth['uid'], provider: auth['provider'])
      if identity.set_provider_data!
        identity.save
        identity
      else
        identity.destroy
        false
      end
    end
  end

  def process_login(datetime)
    self.login_count = self.login_count += 1
    self.logged_in_at = datetime
    save
  end

  handle_asynchronously :process_login

  def refresh_provider_data(auth)
    self.auth = auth
    save if set_provider_data!
  end

  handle_asynchronously :refresh_provider_data

  def set_provider_data!
    if auth['provider'] == "facebook"
      facebook
    elsif auth['provider'] == "rdio"
      rdio
    end
  end

  def facebook
    self.email = auth['info']['email'] rescue nil
    self.avatar = auth['info']['image'] rescue nil
    self.profile_url = auth['extra']['raw_info']['link'] rescue nil
    self.location = auth['info']['location'] rescue nil
    self.token = auth['credentials']['token'] rescue nil
  end

  def rdio
    #Rails.logger.ap auth
  end
end