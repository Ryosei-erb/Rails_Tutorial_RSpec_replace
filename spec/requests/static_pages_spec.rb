require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET #home" do
    it "response successfully" do
      get home_url
      expect(response).to be_success
    end
    it "return a 200 response" do
      get home_url
      expect(response).to have_http_status "200"
    end
    it "title tag is valid" do
      get home_url
      expect(response.body).to include "Home | Ruby on Rails Tutorial Sample App"
    end
  end
  
  describe "GET #help" do
    it "response successfully" do
      get help_url
      expect(response).to be_success
    end
    it "return a 200 response" do
      get help_url
      expect(response).to have_http_status "200"
    end
    it "title tag is valid" do
      get help_url
      expect(response.body).to include "Help | Ruby on Rails Tutorial Sample App"
    end
  end
  
  describe "GET #about" do
    it "response successfully" do
      get about_url
      expect(response).to be_success
    end
    
    it "return a 200 response" do
      get about_url
      expect(response).to have_http_status "200"
    end
    it "title tag is valid in about" do
      get about_url
      expect(response.body).to include "About | Ruby on Rails Tutorial Sample App"
    end
  end
end
