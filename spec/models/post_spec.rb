require 'rails_helper'

RSpec.describe Post, type: :model do
  
  before do
    @post = FactoryBot.create(:post)
  end
  
  it "contentがあり、Userと関連付けされていれば登録できる" do
    expect(@post).to be_valid
  end
  
  it "contentがないと登録できない" do
    post = FactoryBot.build(:post, content: nil)
    
    expect(post).to_not be_valid
  end
  
  it "contentが200文字を越えると登録できない" do
    post = FactoryBot.build(:post, content: "a" * 201)
    
    expect(post).to_not be_valid
  end
end
