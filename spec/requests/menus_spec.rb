require "rails_helper"

RSpec.describe "menusコントローラのテスト", type: :request do 
    before do
        create(:hairdresser)
    end
    it "メニューを作成", js: true do
        visit new_menu_path(hairdresser_login: true)
        find("#menu_name").set "カラー"
        find("#menu_explanation").set "私が必ず可愛くします。ぜひ体験してみてください。"
        find("option[value='30']").select_option
        find("#menu_category1").click
        find(".save_card").click
        expect(page).to have_content "メニューを保存しました"
    end
    it "メニューを編集", js: true do
        create(:menu, status: false)
        visit edit_menu_path(id: 1, hairdresser_login: true)
        find("option[value='30']").select_option
        find("#menu_category1").click
        find(".save_card").click
        expect(page).to have_content "メニューを編集しました"
    end
end