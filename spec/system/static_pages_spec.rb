require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  # before do
  #   driven_by(:rack_test)
  # end
  describe "layouts links" do
    it "Home page" do
      visit root_url
      click_link "Home"
      click_link "Help"
      click_link "About"
      click_link "Contact"
      
    end
  end
end
