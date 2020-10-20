require "rails_helper"

RSpec.describe "chatsコントローラのテスト", type: :request do 
    before do
        create(:user)
        create(:hairdresser)
        create(:room)
        create(:chat)
        create(:reservation)
        create(:style_image)
        create(:menu)
    end
    it "メッセージを送る", js: true do
        visit user_chat_path(user_login: true)
        find(".chat_room_link").click
        find(".chat_form").set "よろしくお願いします"
        find(".message_btn").click
        expect(page).to have_content "よろしくお願いします"
    end
    it "メッセージを入力しないで送信するとalertがでる", js: true do
        visit user_chat_path(user_login: true)
        find(".chat_room_link").click
        find(".message_btn").click
        page.accept_confirm
    end
end