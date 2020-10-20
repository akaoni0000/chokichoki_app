require 'rails_helper'

RSpec.describe "Chatモデルのテスト", type: :model do
    before(:each) do
        create(:hairdresser)
        create(:user)
        create(:room)
        create(:reservation)
    end
    describe "データが正しく保存されるか" do
        context "データが正しく保存されるか" do
            let(:chat) { create(:chat) }
            it "データが正しく保存される" do
                expect(chat.valid?).to eq true;
                binding.pry
            end
        end
    end
    describe "バリデーションのテスト" do
        let(:chat) { create(:chat) }
        context "room_idカラム" do
            before do
                chat.room_id = nil
            end
            it "データが保存されない" do
                expect(chat.valid?).to eq false;
            end
        end

        context "reservation_idカラム" do
            before do
                chat.reservation_id = nil
            end
            it "データが保存されない" do
                expect(chat.valid?).to eq false;
            end
        end
    end
end