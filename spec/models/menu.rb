require 'rails_helper'

RSpec.describe "Menuモデルのテスト", type: :model do
    before(:each) do
        create(:hairdresser)
        create(:user)
    end
    let(:menu) { create(:menu) }
    it "データが保存される" do
        menu.menu_update_status = true
        expect(menu.valid?).to eq true;
    end
    describe "バリデーションのテスト" do
        before(:each) do
            menu.menu_update_status = true
        end
        context "nameカラム" do
            before do
                menu.name = "a"
            end
            it "データが保存されない" do
                expect(menu.valid?).to eq false;
            end
        end
        context "timeカラム" do
            before do
                menu.time = nil
            end
            it "データが保存されない" do
                expect(menu.valid?).to eq false;
            end
        end
        context "explanationカラム" do
            before do
                menu.explanation = "あああ"
            end
            it "データが保存されない" do
                expect(menu.valid?).to eq false;
            end
        end
        context "categoryカラム" do
            before do
                menu.category = "0000"
            end
            it "データが保存されない" do
                expect(menu.valid?).to eq false;
            end
        end
    end
end