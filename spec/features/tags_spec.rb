require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  
  scenario "ユーザーがタグを投稿、削除する" do
    user = FactoryBot.create(:user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    visit tags_path
    
    expect{
      fill_in "タグ名", with: "test tag"
      fill_in "紹介文", with: "test content"
      click_button "投稿"
      
      expect(page).to have_content "投稿しました！"
      expect(page).to have_content "test tag"
      expect(page).to have_content "test content"
      page.has_button? "参加する"
      page.has_link? "タグ削除"
    }.to change(user.tags, :count).by(1)
    
    expect{
      click_link "タグ削除"
      
      expect(page).to have_content "投稿を削除しました"
      expect(page).to_not have_content "test tag"
    }.to change(user.tags, :count).by(-1)
  end
  
  scenario "他のユーザーが投稿したタグは削除できない" do
    FactoryBot.create(:tag)
    
    other_user = FactoryBot.create(:user, email: "other@test.com")
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: other_user.email
    fill_in "Password", with: other_user.password
    click_button "Log in"

    visit tags_path
    
    expect(page).to have_content "test title"
    page.has_no_link? "タグ削除"
  end
  
  scenario "タグに参加、不参加ができる" do
    tag = FactoryBot.create(:tag)
    
    user = FactoryBot.create(:user)
    
    visit root_path
    click_link "ログイン"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    visit tags_path
    click_link "#{tag.title}"
    
    expect{
      page.has_button? "参加"
      click_button "参加"
      
      expect(page).to have_content "タグを追加しました"
      expect(page).to have_content "#{user.name}"
    }.to change(tag.added_user, :count).by(1)
    
    expect{
      page.has_button? "不参加"
      click_button "不参加"
      
      expect(page).to have_content "タグ参加をやめました"
    }.to change(tag.added_user, :count).by(-1)
  end
end
