require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "Sign-up" do
    before do
      @user = FactoryBot.build(:user)
    end
    
    it "invalid signup information" do
      
      expect {
        visit root_url
        click_link "Sign up now!"
        fill_in "Name", with: " "
        fill_in "Email", with: " "
        fill_in "Password", with: " "
        fill_in "Confirmation",with: " "
        click_button "Create my account"
        #expect(page).to have_content ""
        expect(page).to have_content "can't be blank"
      }.to_not change{ User.count}
    end
    
    it "valid signup information" do
      
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
end
