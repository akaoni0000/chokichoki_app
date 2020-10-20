require 'rails_helper'

RSpec.describe "Favoriteモデルのテスト", type: :model do
    before(:each) do
        create(:hairdresser)
        create(:user)
    end
    context "データが保存されるか" do
        let(:favorite) { create(:favorite) }
        it "データが正しく保存される" do
            expect(favorite.valid?).to eq true;
        end
    end
    describe "バリデーションのテスト" do
        let(:favorite) { create(:favorite) }
        context "user_idカラム"
            before do
                favorite.user_id = nil
            end
            it "データが保存されない" do
                expect(favorite.valid?).to eq true;
            end
        end

        context "hairdresser_id" do
            before do
                favorite.hairdresser_id = nil
            end
            it "データが保存されない" do
                expect(favorite.valid?).to eq false;
            end
        end
    end
end