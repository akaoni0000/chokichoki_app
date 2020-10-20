require 'rails_helper'

RSpec.describe "Moneyモデルのテスト", type: :model do
    context "データが正しく保存される" do
        before do
           create(:user)
        end
        let!(:money) { create(:money) }
        it "全て入力してあるので保存される" do
            expect(money.valid?).to eq true
        end
    end
end