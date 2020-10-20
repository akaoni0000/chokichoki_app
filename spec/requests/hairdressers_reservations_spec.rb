require "rails_helper"

RSpec.describe "hairdressers:reservatonsコントローラのテスト", type: :request do 
    context "予約作成機能をテスト" do
        before do
            create(:hairdresser)
            create(:menu)
            visit hairdressers_set_week_calendar_reservation_path(menu_id: 1, hairdresser_login: true)
            page.all(".function")[50].click
            find(".reservation_btn").click
        end
        it "予約を作成する" do
            expect(page).to have_content "変更を保存しました"
        end
        it "予約を削除する" do
            page.all(".function")[50].click
            find(".reservation_btn").click
            expect(page).to have_content "変更を保存しました"
        end
    end
end