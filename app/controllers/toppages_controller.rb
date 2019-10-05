class ToppagesController < ApplicationController
  def index
    if logged_in?
      @users = current_user.followings & current_user.followers
    end
  end
  
  def contact
  end
end
