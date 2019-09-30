class TagsController < ApplicationController
  before_action :correct_user, only: [:destroy]
  
  def index
    @tag = current_user.tags.build if logged_in?
    @tags = Tag.all.order(created_at: :desc).page(params[:page]).per(25)
  end

  def show
    @tag = Tag.find(params[:id])
    @users = @tag.added_user
  end

  def create
    @tag = current_user.tags.build(tag_params)
    if @tag.save
      flash[:success] = '投稿しました！'
      redirect_to @tag
    else
      @tags = Tag.all.order(created_at: :desc).page(params[:page]).per(25)
      flash.now[:danger] = '投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @tag.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to tags_path
  end
  
  private
  
    def tag_params
      params.require(:tag).permit(:title, :content, :image)
    end
    
    def correct_user
      @tag = current_user.tags.find_by(id: params[:id])
      unless @tag
        redirect_to root_url
      end
    end
end
