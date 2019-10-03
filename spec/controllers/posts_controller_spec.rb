require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  
  before do
    @user = FactoryBot.create(:user)
  end
  
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get :index
      expect(response).to be_success
    end
  end
  
  describe "#create" do
    context "ログインユーザーとして" do
      
      it "投稿ができる" do
          post_params = FactoryBot.attributes_for(:post)
          sign_in @user
          expect{
            post :create, params: { post: post_params}
          }.to change(@user.posts, :count).by(1)
      end
    end
    
    context "ゲストユーザーとして" do
      it "投稿をできない、失敗後ログイン画面へ移行している" do
        post_params = FactoryBot.attributes_for(:post)
        expect {
          post :create, params: { post: post_params}
        }.to_not change(Post, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe "#destroy" do
    before do
      @other_user = FactoryBot.create(:user, email: "other@test.com")
      @post = FactoryBot.create(:post, user: @user)
    end
    
    context "ログインユーザーとして" do
      
      it "投稿を削除できる" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @post.id }
        }.to change(@user.posts, :count).by(-1)
      end
      
      it "他のユーザーの投稿は削除できない" do
        sign_in @other_user
        expect {
          delete :destroy, params: { id: @post.id }
        }.to_not change(Post, :count)
      end
      
    end
    
    context "ゲストユーザーとして" do
      it "投稿を削除できない、失敗後ログイン画面へ移行している" do
        expect {
          delete :destroy, params: { id: @post.id }
        }.to_not change(Post, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
