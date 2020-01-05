require 'rails_helper'
include SessionsHelper

RSpec.describe "Sessions", type: :request do
  
  describe "GET #login" do
    before do
      @user = FactoryBot.create(:user)
    end
    describe "ログイン機能" do
      
      context "ログインが成功する場合" do
        it "ログインに成功" do
          get login_path
          post login_path, params: {
            session: {
              email: @user.email, password: @user.password
            }
          }
          expect(is_logged_in?).to be_truthy
          expect(response).to redirect_to @user
          follow_redirect!
          expect(response).to render_template("users/show")
        end
        it "エラーメッセージは表示されない" do
          get login_path
          post login_path, params: {
            session: {
              email: @user.email, password: @user.password
            }
          }
          expect(flash[:danger]).to be_falsey
        end
        it "cookieを保持してログインする" do # remember_tokenが保存できているかのspec
          log_in_as(@user, remember_me: "1")
          expect(cookies["remember_token"]).to be_truthy
        end
        it "cookieを保持せずにログインする" do
          log_in_as(@user)
          delete logout_path
          log_in_as(@user, remember_me: "0")
          expect(cookies["remember_token"]).to be_empty
        end
      
      end
      context "ログインが失敗する場合" do
        it "ログインに失敗" do
          get login_path
          post login_path, params: {
            session: {
              email: " ", password: " "
            }
          }
          expect(is_logged_in?).to be_falsey
        end
        it "エラーメッセージを表示" do
          get login_path
          post login_path, params: {
            session: {
              email: " ", password: " "
            }
          }
          expect(flash[:danger]).to be_truthy
        end
      end
    end
    
    describe "ログアウト機能" do
      context "ログインしているとき" do
        it "ログアウト成功" do
          get login_path
          post login_path, params: { session: { email: @user.email, password: @user.password }}
          expect(is_logged_in?).to be_truthy
          delete logout_path
          expect(is_logged_in?).to be_falsey
        end
      end
      
    end
    
    it"レスポンスが成功する" do
      get login_url
      expect(response).to be_successful
    end
    it"200レスポンスを返す" do
      get login_url
      expect(response).to have_http_status(200)
    end
    
    
  end
end
