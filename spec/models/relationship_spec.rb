require 'rails_helper'

RSpec.describe Relationship, type: :model do
  before do
    @user_a = FactoryBot.create(:user, name: "usa", email: "usa@exam.com")
    @user_b = FactoryBot.create(:user, name: "uk", email: "the_uk@exam.com")
    @relationship = Relationship.new(follower_id: @user_a.id, followed_id: @user_b.id)
  end
  it "relationshipが妥当である" do
    expect(@relationship).to be_valid
  end
  
  it "follower_idが存在する" do
    @relationship.follower_id = nil
    @relationship.valid?
    expect(@relationship.errors[:follower_id]).to include"can't be blank"
  end
  it "followed_idが存在する" do
    @relationship.followed_id = nil
    @relationship.valid?
    expect(@relationship.errors[:followed_id]).to include"can't be blank"
  end
  
end
