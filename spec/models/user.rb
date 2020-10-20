require 'rails_helper'

RSpec.describe "Userモデルのテスト", type: :model do
    let(:user) { create(:user) }
    it "データが正しく保存される" do
        expect(user.valid?).to eq true;
    end
    
    describe "バリデーションのテスト" do
        context "nameカラム" do
            before do 
                user.name = "あ"
            end
            it "保存されない" do
                expect(user.valid?).to eq false;
            end
        end
        context "emailカラム" do
            before do
                user.email = "afadsf"
            end
            it "保存されない" do
                expect(user.valid?).to eq false;
            end
        end
        context "sexカラム" do
            before do
                user.sex = nil
            end
            it "保存されない" do
                expect(user.valid?).to eq false;
            end
        end
    end
end