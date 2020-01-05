require 'rails_helper'

RSpec.describe "Relationships", type: :request do
  describe "/relationships" do
    before do
      @user_a = FactoryBot.create(:user, name: "usa", email: "usa@exam.com")
      @user_b = FactoryBot.create(:user, name: "uk", email: "the_uk@exam.com")
      @relationship = Relationship.new(follower_id: @user_a.id, followed_id: @user_b.id)
    end
    context "ログインしていないとき" do
      it "createアクションはリダイレクトする" do
        expect {
          post relationships_path
        }.to_not change{ Relationship.count }
        expect(response).to redirect_to login_path
      end
      it "destroyアクションはリダイレクトする" do
        expect {
          delete relationship_path(@relationship.followed_id)
        }.to_not change{ Relationship.count }
        expect(response).to redirect_to login_path
      end
    end
  end
end
