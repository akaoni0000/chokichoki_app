require 'rails_helper'

RSpec.describe "usersコントローラ", type: :request do
    describe 'usersコントローラが正常に働く' do
        context "userのデータが作成される" do
            before do
                visit root_path
                find("#user_name", visible: false).set("アンジェラ")
                find("#user_email", visible: false).set("aaa@gmail.com")
                find("#user_password", visible: false).set("chokichoki")
                find("#user_password_confirmation", visible: false).set("chokichoki")
                find("#sex_man", visible: false).set(true)
                find("#user_regi_btn").click
            end
            it 'リクエストは200 OKとなること' do
                binding.pry
                expect(response.status).to eq 200
            end
        end
        # context "美容師のトップ画面が表示される" do 
        #     before do
        #         get hairdresser_top_path
        #     end
        #     it 'リクエストは200 OKとなること' do
        #         expect(response.status).to eq 200
        #     end
        # end
        # context "aboutページが表示される" do 
        #     before do
        #         get about_path
        #     end
        #     it 'リクエストは200 OKとなること' do
        #         expect(response.status).to eq 200
        #     end
        # end
        # context "美容師のトップ画面が表示される" do 
        #     before do
        #         get hairdresser_top_path
        #     end
        #     it 'リクエストは200 OKとなること' do
        #         expect(response.status).to eq 200
        #     end
        # end
    end
end