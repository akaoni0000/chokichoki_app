require 'rails_helper'

RSpec.describe "Reservationモデルのテスト", type: :model do
    before(:each) do
        create(:hairdresser)
        create(:user)
        create(:menu)
    end
    let(:reservation) { create(:reservation) }
    it "データが保存される" do
        expect(reservation.valid?).to eq true;
    end
    describe "バリデーションのテスト" do
        context "start_timeカラム" do
            before do
                reservation.start_time = (Date.today + 1).to_time + 3600*9 + 20
            end
            it "30分単位じゃないのでデータが保存されない" do
                expect(reservation.valid?).to eq false;
            end
        end
    end
end