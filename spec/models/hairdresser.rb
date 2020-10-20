require 'rails_helper'

RSpec.describe "Hairdresserモデルのテスト", type: :model do
    let(:hairdresser) { create(:hairdresser) }
    it "データが正しく保存される" do
        expect(hairdresser.valid?).to eq true;
    end
    
    describe "バリデーションのテスト" do
        let(:hairdresser) { create(:hairdresser) }
        context "nameカラム" do
            before do 
                hairdresser.name = "あ"
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "emailカラム" do
            before do
                hairdresser.email = "afadsf"
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "shop_nameカラム" do 
            before do
                hairdresser.shop_name = "あ"
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "post_numberカラム" do
            before do
                hairdresser.post_number = 111
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "addressカラム" do
            before do
                hairdresser.address = nil
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "shop_latitudeカラム" do
            before do
                hairdresser.shop_latitude = nil
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "shop_longitudeカラム" do
            before do
                hairdresser.shop_longitude = nil
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "confirm_image_idカラム" do
            before do
                hairdresser.confirm_image_id = nil
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
        context "sexカラム" do
            before do
                hairdresser.sex = nil
            end
            it "保存されない" do
                expect(hairdresser.valid?).to eq false;
            end
        end
    end
end