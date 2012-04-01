Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :rdio, configatron.rdio.key, configatron.rdio.secret
  provider :facebook, configatron.fb.key, configatron.fb.secret,
           :scope => 'email,offline_access,publish_stream,user_actions.music,friends_actions.music,publish_actions',
           :display => 'popup'
end