require 'rails_helper'
include SessionsHelper

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user, name: "usa", email: "usa@exam.com")
    @other_user = FactoryBot.create(:user, name: "uk", email: "the_uk@exam.com")
    @admin_user = FactoryBot.create(:user, name: "spain", email: "spain@exam.com", admin: true)
  end
  describe "GET #index" do
    context "ログインしている場合" do
      it "ユーザ名が表示される" do
        log_in_as(@user)
        get users_path
        expect(response).to render_template("users/index")
        expect(response.body).to include @user.name
      end
    end
    context "ログインしていない場合" do
      it "リダイレクトする" do
        get users_path
        expect(response).to redirect_to login_url
      end
    end
  end
  
  describe "GET #show" do
    it "レスポンスが成功する" do
      get user_url @user.id
      expect(response.status).to eq 200
    end
    it "ユーザー名が表示される" do
      get user_url @user.id
      expect(response.body).to include "usa"
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
      it "ユーザーが登録される(そしてログイン）" do
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
  
  describe "GET #edit" do
    
    context "編集に成功する場合" do
      it "編集に成功する" do
        log_in_as(@user)
        get edit_user_path(@user)
        name = "Nishiyama"
        email = "nisi@example.com"
        patch user_path(@user), params: { user: {
          name: name,
          email: email,
          password: @user.password,
          password_confirmation: @user.password }}
        expect(flash[:success]).to be_truthy
        expect(response).to redirect_to @user
        @user.reload
        expect(name).to eq @user.name
        expect(email).to eq @user.email
      end
    end
    context "編集に失敗する場合" do
      it "編集に失敗する" do
        log_in_as(@user)
        get edit_user_path(@user)
        patch user_path(@user), params: { user: { name: " ",
                                                  email: "",
                                                  password: " ",
                                                  password_confirmation: " " }}
      end
      context "ログインしていない場合" do
        it "リダイレクトする" do
          get edit_user_path(@user)
          expect(flash[:danger]).to be_truthy
          expect(response).to redirect_to login_url
        end
      end
     
      context "間違ったユーザーが編集を試みた場合" do
        it "リダイレクトする" do
          log_in_as(@other_user)
          get edit_user_path(@user), params: { user: { name: @user.name, email: @user.email }}
          expect(flash[:success]).to_not be_truthy
          expect(response).to redirect_to root_url
        end
      end
        
    end
  end
  describe "POST #update" do
    
    context "ログインしていない場合" do
      it "リダイレクトする" do
        patch user_path(@user), params: { user: { name: @user.name, email: @user.email,
                                              password: @user.password, password_confirmation: @user.password}}
        expect(flash[:danger]).to be_truthy
        expect(response).to redirect_to login_url  
      end
    end
    context "間違ったユーザーが編集しようと試みた場合" do
      it "リダイレクトする" do
        log_in_as(@other_user)
        patch user_path(@user), params: { user: { name: @user.name, email: @user.email }}
        expect(flash[:success]).to_not be_truthy
        expect(response).to redirect_to root_url
      end
    end
    
  end
  describe "DELETE #destory" do
    context "ログインしていない場合" do
      it "リダイレクトする" do
        expect {
          delete user_path(@user)
        }.to_not change{ User.count}
        expect(response).to redirect_to login_url
      end
    end
    context "管理者でない場合" do
      it "リダイレクトする" do
        log_in_as(@other_user)
        expect {
          delete user_path(@user)
        }.to_not change{ User.count } 
        expect(response).to redirect_to root_url
      end
    end
    
    context "管理者の場合" do
      it "ユーザーを削除する" do
        log_in_as(@admin_user)
        get users_path
        expect(response).to render_template("users/index")
        expect {
          delete user_path(@other_user)
        }.to change{ User.count }.by(-1)
      end
    end
    
  end
  

end
