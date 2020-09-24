require 'rails_helper'
# RSpec.describe Hairdresser, type: :model do
#     let(:hairdresser){create :hairdresser} #省略記法
# end

RSpec.describe "hairdresser_commetsコントローラ", type: :request do
    describe 'コメント投稿' do
        before(:each) do
            create(:hairdresser)
            create(:user)
            create(:menu)
            create(:hairdresser_comment)

            controller.stub(:set_current_hairdresser).and_return(true)
            controller.stub(:notification).and_return(true)
            controller.stub(:session_for_test).and_return(true)
        end
        context "コメントを投稿する画面を表示" do
            before do
                get edit_hairdresser_comment_path(hairdresser_id: 1, id: 1)
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
        context "コメントを投稿する" do
            before do
                visit edit_hairdresser_comment_path(hairdresser_id: 1, id: 1)
                #fill_in "hairdresser_comment[rate]", visible: false, with: 3.0
                # fill_in "hairdresser_comment[comment]", with: "良かったです", visible: false
                #find("#star_form", visible: false)[4].set 3.0
                find('#hairdresser_comment_comment').set 'よろしくね'
                click_button "投稿する"
            end
            it 'コメントを保存してログインする' do
                expect(current_path).to eq "/"
            end
        end
        context "コメントの一覧を表示" do
            before do
                get hairdresser_comments_path
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
    end
end