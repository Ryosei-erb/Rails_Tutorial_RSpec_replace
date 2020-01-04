require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #index"
  
  describe "GET #show" do
    let(:user) { FactoryBot.create(:user) }
    it "レスポンスが成功する" do
      get user_url user.id
      expect(response.status).to eq 200
    end
    it "ユーザー名が表示される" do
      get user_url user.id
      expect(response.body).to include "Ryosei"
    end
  end
  
  describe "GET #new" do
    it "レスポンスが成功する" do
      get signup_url
      expect(response).to be_successful
    end
    it "200レスポンスを返す" do
      get signup_url
      expect(response).to have_http_status(200)
    end
    it "タイトルタグを正しく表示する" do
      get signup_url
      expect(response.body).to include "Sign up | Ruby on Rails Tutorial Sample App"
    end
    
    it "signupテンプレートを表示する" do
      get signup_url
      expect(response.body).to include "Create my account"
    end
  end
  
  describe "POST #create" do
    context "パラメータが妥当な場合" do
      it "リクエストが成功する" do
        user_params = FactoryBot.attributes_for(:user)
        post users_url , params: { user: user_params }
        expect(response).to have_http_status "302"
      end
      it "ユーザーが登録される" do
        user_params = FactoryBot.attributes_for(:user)
        expect{
          post users_url, params: { user: user_params } 
        }.to change{ User.count}.by(1)
        expect(is_logged_in?).to be_truthy
      end
      it "リダイレクトする" do
        user_params = FactoryBot.attributes_for(:user)
        post users_url, params: { user: user_params }
        expect(response).to redirect_to User.last
      end
    end
    context "パラメータが不正な場合" do
      it "リクエストが成功する" do
        user_params = FactoryBot.attributes_for(:user, :invalid)
        post users_url , params: { user: user_params }
        expect(response.status).to eq 200
      end
      it "ユーザーが登録されない" do
        user_params = FactoryBot.attributes_for(:user, :invalid)
        expect{
          post users_url, params: { user: user_params } 
        }.to_not change{ User.count}
        expect(is_logged_in?).to be_falsey
      end
      it "エラーが表示される" do
        user_params = FactoryBot.attributes_for(:user, :invalid)
        post users_url , params: { user: user_params }
        expect(response.body).to include "error"
      end
    end
  end
  
  describe "GET #edit"
  describe "POST #update"
  describe "DELETE #destory"
end
