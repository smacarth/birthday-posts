class FacebookUser < ActiveRecord::Base
  def self.cron #connect to facebook
    agent = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3'}
    agent.user_agent_alias = 'iPhone'
    agent.pluggable_parser.default = Mechanize::Download
    
    local_hostname = "https://" + HEROKU_APP_NAME + ".herokuapp.com/"
    home_page = agent.get(URI.join local_hostname, "/facebook_users")
    login_page = home_page.link_with(:id => "login").click
    begin
      login_form = login_page.form_with(:id => "login_form")
      login_form.email = FB_USER
      login_form.pass = FB_PASS
      fb_page = login_form.submit
    rescue
      fb_page = login_page
    end
  end

  def self.messages(friend) #messages to send
    messages = ["Happy birthday!", "Happy Birthday!", "happy birthday!", "happy birthday, hope all is well!", "happy birthday!"]
    unless dont_include_name(friend['id'], friend['first_name'])
      messages << "happy birthday #{friend['first_name']}!"
      messages << "Happy birthday #{friend['first_name']}!" 
    end
    messages[rand(messages.size)]
  end
  
  def self.black_list(id) #don't send birthday messages to these friends
    removed_ids = [] #add ids here as strings
    true if removed_ids.include? id
  end
  
  def self.dont_include_name(id, name) #don't include name in post if contains non-alphabet characters, or in removed_ids array
    removed_ids = [] #add ids here as strings
    true if removed_ids.include?(id) || !(name =~ /^[a-z]+$/i)
  end
end