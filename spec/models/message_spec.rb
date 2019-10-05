require 'rails_helper'

RSpec.describe Message, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user, email: "other@email.com")
    @user.follow(@other_user)
    @other_user.follow(@user)
    @message = Message.new(from_id: @user.id, to_id: @other_user.id, 
                            room_id: "#{@user.id}-#{@other_user.id}", content: "test content")
  end
  
  it "登録ができている" do
    expect(@message).to be_valid
  end
  
  it "contentが150文字を超えてはいけない" do
    @message.content = "a" * 151
    expect(@message).to_not be_valid
  end
  
  it "from_idがないと登録できない" do
    @message.from_id = nil
    expect(@message).to_not be_valid
  end
  
  it "to_idがないと登録できない" do
    @message.to_id = nil
    expect(@message).to_not be_valid
  end
  
  it "room_idがないと登録できない" do
    @message.room_id = nil
    expect(@message).to_not be_valid
  end
  
  it "contentがないと登録できない" do
    @message.content = nil
    expect(@message).to_not be_valid
  end
end
