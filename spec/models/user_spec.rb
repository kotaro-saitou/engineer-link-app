require 'rails_helper'

RSpec.describe User, type: :model do
  
  before do
    @user = FactoryBot.create(:user)
  end
  
  it "名前とメールアドレスとパスワードがあれば登録できる" do
    expect(@user).to be_valid
  end
  
  it "名前がないと登録できない" do
    user = FactoryBot.build(:user, name: nil)
    
    user.valid?
    
    expect(user.errors[:name]).to include("can't be blank")
  end
  
  it "メールアドレスがないと登録できない" do
    user = FactoryBot.build(:user, email: nil)
    
    user.valid?
    
    expect(user.errors[:email]).to include("can't be blank")
  end
  
  it "メールアドレスが重複していると登録できない" do
    user = FactoryBot.build(:user, email: @user.email)
  
    user.valid?
    
    expect(user.errors[:email]).to include("has already been taken")
  end
  
  it "パスワードが暗号化されている" do
    expect(@user.password_digest).to_not eq 'password'
  end
  
  describe "ユーザーをフォローする機能" do
  
    it "自分ではないユーザーのフォローとアンフォローができる" do
        
      other_user = FactoryBot.create(:user, email: "test2@test.com")
      @user.follow(other_user)
      expect(@user.following?(other_user)).to be true
      
      @user.unfollow(other_user)
      expect(@user.following?(other_user)).to be false
    end
    
  end
  
  describe "タグの追加と削除" do
  
    it "タグの追加と削除ができる" do
        
      tag = Tag.create(
        title: "test tag",
        content: "test content",
        user_id: @user.id
        )
        
      @user.adding(tag)
      
      expect(@user.adding?(tag)).to be true
      
      @user.remove(tag)
      
      expect(@user.adding?(tag)).to be false
    end

  end
end
