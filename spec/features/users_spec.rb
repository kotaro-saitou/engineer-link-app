require 'rails_helper'

RSpec.feature "Users", type: :feature do
  scenario "ユーザー登録ができる" do
    visit root_path
    click_link "Sign up", match: :first
    
    expect{
      fill_in "Name", with: "test user"
      fill_in "Email", with: "testuser@test.com"
      fill_in "Password", with: "password"
      fill_in "Confirmation", with: "password"
      click_button "Sign up"
    }.to change(User, :count).by(1)
    
    expect(page).to have_content "test user"
    page.has_button? "プロフィール編集"
  end
  
  scenario "ユーザー情報を編集できる" do
    user = FactoryBot.create(:user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    
    click_link "プロフィール編集"
    
    fill_in "Name", with: "edit name"
    fill_in "Email", with: "edit@email.com"
    fill_in "Profile", with: "edit profile"
    fill_in "Password", with: user.password
    fill_in "Confirmation", with: user.password
    click_button "編集"
    
    expect(page).to have_content "編集しました"
    expect(page).to have_content "edit name"
    expect(page).to have_content "edit profile"
  end
  
  scenario "ユーザーをフォロー、アンフォローができる" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user, name: "other", email: "other@email.com")
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    
    visit user_path other_user
    expect{
      click_button "いいね！"
    }.to change(user.followings, :count).by(1)
    
    expect{
      click_button "いいね解除"
    }.to change(user.followings, :count).by(-1)
    
  end
  
  scenario "相互フォローはトップページに表示される" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user, name: "other", email: "other@email.com")
    other_user.follow(user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    
    visit root_path
    expect(page).to_not have_content "other"
    
    visit user_path other_user
    click_button "いいね！"
    visit root_path
    
    expect(page).to have_content "other"
    page.has_link? "メッセージ"
  end
  
  scenario "フォローされていて、フォローを返していないユーザーが表示される" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.create(:user, name: "other", email: "other@email.com")
    other_user.follow(user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    
    visit followers_user_path user
    expect(page).to have_content "other"
    page.has_link? "other"
  end
end
