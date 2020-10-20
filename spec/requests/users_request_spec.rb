require 'rails_helper'

RSpec.describe "usersコントローラ", type: :request do
    context "user登録をテスト" do
        before do
            visit root_path(not_login: true)
            find("#new_user").click
            find("#link_user_sign_up").click
        end
        it "userを作成できる", js: true do
            find("#user_name").set "テストマン"
            find("#user_email").set "abc@gmail.com"
            find("#user_password").set "chokichoki"
            find("#user_password_confirmation").set "chokichoki"
            find("#sex_man").click
            find("#user_regi_btn").click
            expect(page).to have_context "確認メールを送信しました"
        end
        it "userを作成できない", js: true do
            find("#user_regi_btn").click
            expect(page).to have_context "正しいメールアドレスを入力してください"
        end
    end
    context "ログイン機能をテスト" do
        let!(:user) { create(:user) }
        it "ログインできる" do
            post user_login_path(email: user.email, password: user.password, not_login: true), xhr: true
            expect(session[:user_id]).to eq 1 
        end
        it "ログインできない" do
            post user_login_path(email: "a@gmail.com", password: user.password, not_login: true), xhr: true
            expect(session[:user_id]).to eq nil
        end
    end
end