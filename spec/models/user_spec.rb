require 'rails_helper'
include SessionsHelper

RSpec.describe User, type: :model do
  before do
   @user = FactoryBot.create(:user, name: "usa", email: "usa@exam.com")
   @other_user = FactoryBot.create(:user, name: "uk", email: "the_uk@exam.com")
   @unfollow_user = FactoryBot.create(:user, name: "flance", email: "flance@exam.com")
  end
  
  context "有効性と存在性のspec" do
    it "名前とメールアドレスがあれば有効"  do
      expect(@user).to be_valid
    end
  
    it "名前が無ければ無効" do
      @user.name = ""
      @user.valid?
      expect(@user.errors[:name]).to include("can't be blank")
    end
  
    it "メールアドレスが無ければ無効" do
      @user.email = ""
      @user.valid?
      expect(@user.errors[:email]).to include("can't be blank")
    end
    it "パスワードに空白を使うと、無効" do
      @user.password = @user.password_confirmation = "" * 6
      expect(@user).to_not be_valid
    end
    
  end
  
  context "長さのspec" do
    it "名前の字数が51字以上であれば無効" do
      @user.name = "a" * 51
      @user.valid?
      expect(@user.errors[:name]).to include("is too long (maximum is 50 characters)")
    end
  
    it "メールアドレスの字数が255字以上であれば無効" do
      @user.email = "a" * 244 + "@example.com"
      @user.valid?
      expect(@user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end
    it "パスワードは6字以上でなければ、無効" do
      @user.password = @user.password_confirmation = "a" * 5
      expect(@user).to_not be_valid
    end
  
  end
  
  context "formatのspec" do
    it "メールアドレスのフォーマットが正しければ、有効" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
        valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
        end
    end
  
    it "メールアドレスのフォーマットが間違っていれば、無効" do
      invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
      invalid_addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.valid?
        expect(@user).to be_invalid 
      end
    end
    context "一意性のspec" do
      it "メールアドレスが同じユーザーは、認められない" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        expect(duplicate_user).to be_invalid
      end
    end
    context "micropost関連のspec" do
      it "ユーザーを削除すると、マイクロポストも削除される" do
        @user.save
        @user.microposts.create!(content: "Long")
        expect {
          @user.destroy
        }.to change{ Micropost.count }.by(-1)
      end
    end
    context "following関連のspec" do
      it "フォローして、アンフォローする" do
        expect(@user.following?(@other_user)).to be_falsey
        @user.follow(@other_user)
        expect(@user.following?(@other_user)).to be_truthy
        expect(@other_user.followers.include?(@user)).to be_truthy
        @user.unfollow(@other_user)
        expect(@user.following?(@other_user)).to be_falsey
      end
      it "フィードで自分とフォローしているユーザーのみ表示する" do
        @user.follow(@other_user)
        @other_user.microposts.each do | post_following |
          expect(@user.feed.include?(post_following)).to be_valid
        end
        @user.microposts.each do | post_self |
          expect(@user.feed.include?(post_self)).to be_valid
        end
        @unfollow_user.microposts.each do | post_unfollowed |
          expect(@user.feed.include?(post_unfollowed)).to be_invalid
        end
      end
      
    end
  end
  
end
