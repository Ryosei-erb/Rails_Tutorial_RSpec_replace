require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  before do
    driven_by(:rack_test)
  end
  it "トップページのリンク先を正しく遷移する" do
    visit root_url
    expect(page).to have_link "Home"
    expect(page).to have_link "Help"
    expect(page).to have_link "About"
    expect(page).to have_link "Contact"
  end

    
 
end
