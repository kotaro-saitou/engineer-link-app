class MessagesController < ApplicationController
  before_action :mutual_relation
  
  def index
  end

  def show
    @room_id = message_room_id(current_user, @user)
    #if params[:content] != nil
      #Message.create!(content: params[:content], from_id: current_user.id, to_id: @user.id, room_id: @room_id)
    #end
    @messages = Message.recent_in_room(@room_id)
  end
  
  private
  
    def message_room_id(first_user, second_user)
      first_id= first_user.id.to_i
      second_id = second_user.id.to_i
      if first_id < second_id
        "#{first_user.id}-#{second_user.id}"
      else
        "#{second_user.id}-#{first_user.id}"
      end
    end
    
    def mutual_relation
      unless logged_in?
        flash[:danger] = "ログインしてください"
        redirect_to login_path
        return
      end
      @user = User.find(params[:id])
      unless current_user.followings.include?(@user) && @user.followings.include?(current_user)
        flash[:danger] = "相互フォローではありません"
        redirect_to root_path
      end
    end
end
