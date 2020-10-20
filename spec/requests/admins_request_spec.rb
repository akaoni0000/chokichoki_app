require "rails_helper"

RSpec.describe "adminsコントローラのテスト", type: :request do 
    let!(:admin) { create(:admin) }
    it "adminのログイン画面を表示" do
        get admins_login_form_path
        expect(response.status).to eq 200;
    end
    it "adminの会員一覧画面を表示" do
        get admins_user_index_path(admin_login: true)
        expect(response.status).to eq 200;
    end
    it "adminの承認画面待ち画面を表示" do
        get admins_hairdresser_judge_index_path(admin_login: true)
        expect(response.status).to eq 200;
    end
    it "adminの会員チャート画面を表示" do
        get admins_user_chart_path(admin_login: true)
        expect(response.status).to eq 200;
    end
    it "adminの美容師チャート画面を表示" do
        get admins_hairdresser_chart_path(admin_login: true)
        expect(response.status).to eq 200;
    end
    it "adminの売り上げチャート画面を表示" do
        get admins_sell_chart_path(admin_login: true)
        expect(response.status).to eq 200;
    end
    context "ログインできるかテスト" do
        it "ログインする" do
            visit admins_login_form_path
            find(".admin_login_email").set admin.email
            find(".admin_login_password").set admin.password
            find(".btn_admin").click
            expect(current_path).to eq "/admins/user_index"
        end
        it "ログインできない" do
            visit admins_login_form_path
            find(".admin_login_email").set "bbb@gmail.com"
            find(".admin_login_password").set admin.password
            find(".btn_admin").click
            expect(current_path).to eq "/admins/login"
        end
    end
    
end