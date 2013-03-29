module Facebook
  CONFIG = YAML.load_file(Rails.root.join("config/facebook.yml"))[Rails.env]
  APP_ID = CONFIG['app_id']
  SECRET = CONFIG['secret']
  CALLBACK = CONFIG['callback_url']
  SSL_CERT_FILE = 'c:/rails_ssl/cacert.pem'
  ca_file =  Rails.env == 'production' ? '/usr/lib/ssl/certs/ca-certificates.crt' : SSL_CERT_FILE
  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, APP_ID, SECRET, {:scope => 'email', :client_options => {:ssl => {:ca_file => ca_file}}}
  end
end

Koala::Facebook::OAuth.class_eval do
  def initialize_with_default_settings(*args)
    case args.size
      when 0, 1
        raise "application id and/or secret are not specified in the config" unless Facebook::APP_ID && Facebook::SECRET
        initialize_without_default_settings(Facebook::APP_ID.to_s, Facebook::SECRET.to_s, args.first)
      when 2, 3
        initialize_without_default_settings(*args) 
    end
  end 

  alias_method_chain :initialize, :default_settings 
end