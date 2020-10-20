require "rails_helper"

RSpec.describe "chatsコントローラのテスト", type: :request do 
    before do
        create(:user)
    end
    let!(:hairdresser) { create(:hairdresser) }
    it "お気に入り登録する", js: true do
        visit hairdressers_path(user_login: true)
        find(".hairdresser_show_link").click
        find(".favorite_btn").click
        find(".show_remove").click
        find("#open_user_menu").click
        find(".favorite_index_btn").click
        expect(page).to have_selector '.favorite_name', text: hairdresser.name
    end
end
