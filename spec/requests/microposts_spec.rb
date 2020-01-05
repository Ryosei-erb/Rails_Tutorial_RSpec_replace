require 'rails_helper'
include SessionsHelper

RSpec.describe "Microposts", type: :request do
  describe " /microposts" do
    before do
      @user = FactoryBot.create(:user, name: "usa", email: "usa@exam.com")
      @other_user = FactoryBot.create(:user, name: "uk", email: "the_uk@exam.com")
      @micropost = FactoryBot.create(:micropost,content: "China", user: @user)
    end
    
    context "ログインしていないとき" do
      it "投稿を試みると、リダイレクトする" do
        expect {
          post microposts_path, params: { micropost: { content:  "GOT" }}
        }.to_not change{ Micropost.count }
        expect(response).to redirect_to login_path
      end
      it "削除を試みると、リダイレクトする" do
        expect {
          delete micropost_path(@micropost)
        }.to_not change{ Micropost.count }
        expect(response).to redirect_to login_path
      end
    end
    context "間違ったユーザーでログインしたとき" do
     
      it "削除を試みると、リダイレクトする" do
        log_in_as(@other_user)
        expect {
          delete micropost_path(@micropost)
        }.to_not change{ Micropost.count }
      end
    end
    context "ログインしているとき" do
      
      it "空のマイクロポストを投稿する" do
        log_in_as(@user)
        get root_path
        expect {
          post microposts_path, params: { micropost: { content: "" }}
        }.to_not change{ Micropost.count }
        expect(response.body).to include "error"
        expect(response).to render_template("static_pages/home")
      end
      
      it "条件に合致したマイクロポストを投稿する" do
        log_in_as(@user)
        get root_path
        expect {
          post microposts_path, params: { micropost: { content: "China" }}
        }.to change{ Micropost.count }.by(1)
        expect(response).to redirect_to root_url
      end
      
      it "投稿を削除する" do
        log_in_as(@user)
        get root_path
        expect{
          delete micropost_path(@micropost)
        }.to change{ Micropost.count }.by(-1)
        expect(response).to redirect_to root_url
      end
      
    end
  end
end
