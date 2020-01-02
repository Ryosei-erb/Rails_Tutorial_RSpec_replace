require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/new" do
    it "response successfully" do
      get signup_url
      expect(response).to be_successful
    end
    it "return a 200 response" do
      get signup_url
      expect(response).to have_http_status(200)
    end
    it "valid the title tag"
  end
end
