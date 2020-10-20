require "rails_helper"

RSpec.describe "users::hairdressersコントローラのテスト", type: :request do 
    before do
        create(:hairdresser)
    end
    it "美容師一覧で美容師の画像をクリックするとshowモーダルが出現", js: true do
        visit hairdressers_path(not_login: true)
        find(".hairdresser_show_link").click
        expect(page).to have_content "プロフィール"
    end
end