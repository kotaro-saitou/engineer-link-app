require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  
  describe "#index" do
    it "正常にレスポンスを返すこと" do
      get :index
      expect(response).to be_success
    end
  end
  
  describe "#show" do
    
    before do
      @tag = FactoryBot.create(:tag)
    end
    
    it "正常にレスポンスを返すこと" do
      get :show, params: {id: @tag.id}
      expect(response).to be_success
    end
  end
  
  describe "#create" do
    
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag, user: @user)
    end
    
    context "ログインユーザーとして" do
      it "タグを追加できる" do
        tag_params = FactoryBot.attributes_for(:tag)
        sign_in @user
        expect{
          post :create, params: {tag: tag_params}
        }.to change(@user.tags, :count).by(1)
      end
    end
    
    context "ゲストユーザーとして" do
      it "タグを追加できない、失敗後ログイン画面へ移行している" do
        tag_params = FactoryBot.attributes_for(:tag)
        expect{
          post :create, params: {tag: tag_params}
        }.to_not change(Tag, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
  
  describe "#destroy" do
    
    before do
      @user = FactoryBot.create(:user)
      @tag = FactoryBot.create(:tag, user: @user)
      @other_user = FactoryBot.create(:user, email: "other@test.com")
    end
    
    context "ログインユーザーとして" do
      it "タグを削除できる" do
        sign_in @user
        expect {
          delete :destroy, params: { id: @tag.id }
        }.to change(@user.tags, :count).by(-1)
      end
      
      it "他のユーザーのタグを削除できない" do
        sign_in @other_user
        expect{
          delete :destroy, params: { id: @tag.id }
        }.to_not change(Tag, :count)
      end
    end
    
    context "ゲストユーザーとして" do
      it "タグを削除できない、失敗後ログイン画面へ移行している" do
        expect {
          delete :destroy, params: { id: @tag.id }
        }.to_not change(Tag, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
