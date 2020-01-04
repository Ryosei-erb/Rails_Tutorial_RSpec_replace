require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  
    
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
  
  it "パスワードに空白を使うと、無効" do
    @user.password = @user.password_confirmation = "" * 6
    expect(@user).to_not be_valid
  end
  
  it "パスワードは6字以上でなければ、無効" do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).to_not be_valid
  end
  
  it "メールアドレスが同じユーザーは、認められない" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).to be_invalid
  end
end
