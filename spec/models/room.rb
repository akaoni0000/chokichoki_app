require 'rails_helper'

RSpec.describe "Roomモデルのテスト", type: :model do
    context "データが正しく保存される" do
        let!(:room) { create(:room) }
        it "全て入力してあるので保存される" do
            expect(room.valid?).to eq true
        end
    end
end