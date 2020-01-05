require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @micropost = @user.microposts.build(content: "China")
  end
  describe "micropostモデルのバリデーション" do
    it "マイクロポストがあれば有効" do
      expect(@micropost).to be_valid
    end
    it "user_idが無ければ、無効" do
      @micropost.user_id = nil
      @micropost.valid?
      expect(@micropost.errors[:user_id]).to include "can't be blank"
    end
    it "マイクロポストが空白であれば、無効" do
      @micropost.content = " "
      @micropost.valid?
      expect(@micropost.errors[:content]).to include "can't be blank"
    end
    it "マイクロポストの字数が141以上であれば無効" do
      @micropost.content = "a" * 141
      @micropost.valid?
      expect(@micropost.errors[:content]).to include "is too long (maximum is 140 characters)"
    end
   
  end
end
