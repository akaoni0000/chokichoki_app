require 'rails_helper'

RSpec.describe "ChatMessageモデルのテスト", type: :model do
    before(:each) do
        create(:user)
        create(:hairdresser) 
        create(:room)
    end
    describe "データが正しく保存されるかテスト" do
        context "データが正しく保存されるか" do
            let(:chat_message) { create(:chat_message) }
            it "データが保存される" do
                expect(chat_message.valid?).to eq true;
            end
        end
    end
    describe 'バリデーションのテスト' do
        context "messageカラム imageカラム style_imagesカラムがすべてnilのとき" do
            let(:chat_message) { create(:chat_message) }
            before do
                chat_message.message = nil
            end
            it "データが保存されない" do
                expect(chat_message.valid?).to eq false;
            end
        end
    end
end