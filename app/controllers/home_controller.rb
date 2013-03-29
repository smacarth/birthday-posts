class HomeController < ApplicationController
  def index #app home page redirects to facebook
    redirect_to "http://www.facebook.com/"
  end
end