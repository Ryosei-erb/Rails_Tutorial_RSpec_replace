require 'rails_helper'

RSpec.describe "Users", type: :system do
  
    before do
      driven_by(:rack_test)
      @user = FactoryBot.build(:user)
    end
    describe "ユーザー登録機能" do
      context "ユーザー登録が成功するとき" do
       
        it "ユーザーが登録される" do
          
          expect {
            visit root_url
            click_link "Sign up now!"
            fill_in "Name", with: @user.name
            fill_in "Email", with: @user.email
            fill_in "Password", with: @user.password
            fill_in "Confirmation",with: @user.password
            click_button "Create my account"
          }.to change{ User.count}.by(1)
          
        end
      end
      context "ユーザー登録が失敗するとき" do
        it "ユーザーが登録されない" do
          expect {
            visit root_url
            click_link "Sign up now!"
            fill_in "Name", with: " "
            fill_in "Email", with: " "
            fill_in "Password", with: " "
            fill_in "Confirmation",with: " "
            click_button "Create my account"
            expect(page).to have_content "can't be blank"
          }.to_not change{ User.count}
        end
      end
    end
    
    describe "ログイン・ログアウト機能" do
      context "ログインが成功するとき" do
        before do
          @user = FactoryBot.create(:user, email: "a@example.com",password: "password")
        end
        it "ログインする" do
          visit login_url
          fill_in "Email",with: "a@example.com"
          fill_in "Password", with: "password"
          click_button "Log in"
          
          expect(page).to have_link "Log out", href: logout_path
          expect(page).to have_link "Profile", href: user_path(@user)
          expect(page).to have_link "Settings"
          expect(page).to_not have_link "Log in", href: login_url
    
        end
      end
       
      context "ログインが失敗するとき" do
        it "ログインできない（フラッシュもすぐに消える仕様）" do
          visit login_url
          expect(page).to have_selector ".login-form"
          fill_in "Email", with: " "
          fill_in "Password", with: " "
          click_button "Log in"
          expect(page).to have_selector ".alert-danger", text: "INVALID"
          expect(current_path).to eq login_path
          visit root_url
          expect(page).to_not have_selector ".alert-danger", text: "INVALID"
        end
      end
    end
    
end
