require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET #home" do
    it "レスポンスが成功する" do
      get home_url
      expect(response).to be_successful
    end
    it "200レスポンスを返す" do
      get home_url
      expect(response).to have_http_status "200"
    end
    it "タイトルタグを正しく表示する" do
      get home_url
      expect(response.body).to include "Ruby on Rails Tutorial Sample App"
    end
    it "homeテンプレートを表示する" do
      get root_url
      expect(response.body).to include "Welcome to the Sample App" 
    end
  end
  
  describe "GET #help" do
    it "レスポンスが成功する" do
      get help_url
      expect(response).to be_successful
    end
    it "200レスポンスを返す" do
      get help_url
      expect(response).to have_http_status "200"
    end
    it "タイトルタグを正しく表示する" do
      get help_url
      expect(response.body).to include "Help | Ruby on Rails Tutorial Sample App"
    end
    it "helpテンプレートを表示する" do
      get help_url
      expect(response.body).to include "Help"
    end
  end
  
  describe "GET #about" do
    it "レスポンスが成功する" do
      get about_url
      expect(response).to be_successful
    end
    
    it "200レスポンスを返す" do
      get about_url
      expect(response).to have_http_status "200"
    end
    it "タイトルタグを正しく表示する" do
      get about_url
      expect(response.body).to include "About | Ruby on Rails Tutorial Sample App"
    end
    it "aboutテンプレートを表示する" do
      get about_url
      expect(response.body).to include "About"
    end
  end
  
  describe "GET #contact" do
     it "レスポンスが成功する" do
      get contact_url
      expect(response).to be_successful
    end
    it "200レスポンスを返す" do
      get contact_url
      expect(response).to have_http_status "200"
    end
    it "タイトルタグを正しく表示する" do
      get contact_url
      expect(response.body).to include "Contact | Ruby on Rails Tutorial Sample App"
    end
    it "contactテンプレートを表示する" do
      get contact_url
      expect(response.body).to include "Contact"
    end
  end
end
