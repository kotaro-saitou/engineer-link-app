require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  
  scenario "ユーザーが記事を投稿、削除をする" do
    
    user = FactoryBot.create(:user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    visit posts_path
    
    expect{
      page.has_field? "投稿内容"
      page.has_button? "投稿"
      
      fill_in "投稿内容", with: "Test content"
      click_button "投稿"
      
      expect(page).to have_content "メッセージを投稿しました！"
      expect(page).to have_content "Test content"
      expect(page).to have_content "#{user.name}"
    }.to change(user.posts, :count).by(1)
    
    visit posts_path
    
    expect{
      expect(page).to have_content "Test content"
      
      click_link "delete"
      expect(page).to have_content "投稿を削除しました"
      expect(page).to_not have_content "Test content"
    }.to change(user.posts, :count).by(-1)
  end
  
  scenario "ログインしていないユーザーは投稿画面が表示されていない" do
    visit posts_path
    
    page.has_no_field? "投稿内容"
    page.has_no_button? "投稿"
  end
  
  scenario "他のユーザーの投稿にdeleteはない" do
    
    FactoryBot.create(:post)
    other_user = FactoryBot.create(:user, email: "other@test.com")
    
    visit login_path
    click_link "ログイン"
    fill_in "Email", with: other_user.email
    fill_in "Password", with: other_user.password
    click_button "Log in"
    
    visit posts_path
    
    expect(page).to have_content "test content"
    page.has_no_link? "delete"
    
  end
  
end
