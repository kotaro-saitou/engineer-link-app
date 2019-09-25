class UsersController < ApplicationController
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.limit(10).order(id: :desc).page(params[:page]).per(25)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = 'ユーザー登録をしました'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザー登録に失敗しました'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if current_user == @user
      if @user.update(user_params)
        flash[:success] = '編集しました'
        redirect_to @user
      else
        flash.now[:danger] = '編集が失敗しました'
        render :edit
      end
    else
      redirect_to root_url
    end
  end
  
  def add_tag
    @user = User.find(params[:id])
    @adding = @user.adding_tags
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
  end
  
  def followers
    @user = User.find(params[:id])
    #@followers = @user.followers.page(params[:page])
    @followers = @user.followers.where.not(id: @user.followings.ids).page(params[:page])
  end
  
  private
  
    def user_params
      params.require(:user).permit(:avatar, :name, :email, :profile, :password, :password_confirmation)
    end
    
end
