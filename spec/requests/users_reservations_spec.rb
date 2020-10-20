require 'rails_helper'

RSpec.describe "users::reservationsコントローラ", type: :request do
    it "予約できる", js: true do
        create(:user)
        create(:hairdresser)
        create(:menu)
        create(:reservation, user_id: nil)
        visit edit_users_reservation_path(id: 1, user_login: true)
        find("#point").click
        find(".reservation_btn").click
        expect(page).to have_context "予約が完了しました"
    end
end