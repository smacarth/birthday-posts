class FacebookUsersController < ApplicationController
  def index #connect to oauth
    session[:oauth] = Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET, Facebook::CALLBACK + 'facebook_users/login')
    @auth_url =  session[:oauth].url_for_oauth_code(:permissions=>"friends_birthday, publish_stream")
  end
  
  def login #post on friend's walls for birthdays
    @cb_url = Facebook::CALLBACK + "facebook_users/login"
    session[:access_token] = session[:oauth].get_access_token(params[:code], :redirect_uri => @cb_url)
    api = Koala::Facebook::API.new(session[:access_token])
    @friends = api.get_connections("me", "friends", "fields" =>"birthday, first_name, last_name") 

    @friends.each do |friend|
       if friend['birthday'] && friend['birthday'][0..4] == Time.now.strftime("%m/%d") && !FacebookUser.black_list(friend['id'])
         api.put_wall_post(FacebookUser.messages(friend), {:name => "..."}, "#{friend['id']}")
       end
    end 
  end
end