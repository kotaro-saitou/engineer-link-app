require 'rails_helper'

RSpec.describe Tag, type: :model do
  
  before do
    @tag = FactoryBot.create(:tag)
  end
  
  it "タイトルとcontentがあり、Userと関連付けされていれば登録できる" do
    expect(@tag).to be_valid
  end
  
  it "タイトルがないと登録できない" do
    
    tag = FactoryBot.build(:tag, title: nil)
      
    expect(tag).to_not be_valid
      
  end
  
  it "contentがないと登録できない" do
    
    tag = FactoryBot.build(:tag, content: nil)
      
    expect(tag).to_not be_valid
      
  end
  
  it "タイトルが50文字を越えると登録できない" do
    tag = FactoryBot.build(:tag, title: "a" * 51)
    
    expect(tag).to_not be_valid
  end
  
  it "contentが100文字を越えると登録できない" do
    tag = FactoryBot.build(:tag, content: "a" * 101)
    
    expect(tag).to_not be_valid
  end
end
