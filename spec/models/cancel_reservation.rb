require 'rails_helper'

RSpec.describe "CancelReservationモデルのテスト", type: :model do
    context "データが正しく保存される" do
        before do
           create(:user)
           create(:hairdresser)
           create(:menu)
           create(:reservation)
        end
        let!(:cancel_reservation) { create(:cancel_reservation) }
        it "全て入力してあるので保存される" do
            expect(cancel_reservation.valid?).to eq true
        end
    end
end