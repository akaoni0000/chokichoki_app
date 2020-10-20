require "rails_helper"

RSpec.describe "hairdressersコントローラのテスト", type: :request do 
    context "美容師登録のテスト" do
        before do
            visit hairdresser_top_path(not_login: true)
            find("#new_hairdresser").click
        end
        it "美容師登録", js: true do
            find("#hairdresser_name").set "テストさん"
            find("#hairdresser_email").set "ttt@gmail.com"
            find("#hairdresser_shop_name").set "テストショップ"
            find("#hairdresser_post_number").set "1111111"
            find("#hairdresser_password").set "chokichoki"
            find("#hairdresser_password_confirmation").set "chokichoki"
            find("#confirm_img").set "#{Rails.root}/db/fixtures/images/sky.jpg"
            find("#hairdresser_sex_man").click
            find("#hairdresser_btn").click
            expect(page).to have_content "確認メールを送信しました。"
        end 
        it "美容師登録できない", js: true do
            find("#hairdresser_btn").click
            expect(current_path).to eq "/hairdresser_top"
        end
    end
    context "ログイン機能をテスト" do
        let!(:hairdresser) { create(:hairdresser) }
        it "ログインできる", js: true do
            visit hairdresser_top_path(not_login: true)
            find("#login_hairdresser").click
            find(".hairdresser_login_email").set hairdresser.email
            find(".hairdresser_login_password").set hairdresser.password
            find(".hairdresser_form_login_btn").click
            expect(page).to have_content "アカウント"
        end
        it "ログインできない", js: true do
            visit hairdresser_top_path(not_login: true)
            find("#login_hairdresser").click
            find(".hairdresser_login_email").set "a@gmail.com"
            find(".hairdresser_login_password").set hairdresser.password
            find(".hairdresser_form_login_btn").click
            expect(page).to have_content "メールアドレスまたはパスワードが違います"
        end
        it "ログアウトする" do
            visit hairdresser_path(id: 1, hairdresser_login: true)
            find(".hairdresser_logout_btn").click
            expect(current_path).to eq "/hairdresser_top"
        end
    end
    context "編集機能のテスト" do
        before do
            create(:hairdresser)
            visit edit_hairdresser_path(id: 1, hairdresser_login: true)
        end
        it "編集機能できる", js: true do
            find("#hairdresser_btn").click
            expect(page).to have_content "プロフィール情報を更新しました"
        end
        it "編集できない", js: true do
            find("#hairdresser_name").set ""
            find("#hairdresser_btn").click
            expect(page).to have_content "名前は2文字以上10文字以下で入力してください"
        end
    end
end