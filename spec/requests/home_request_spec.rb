require 'rails_helper'

RSpec.describe "homeコントローラ", type: :request do
    describe 'homeコントローラのviewが正しく表示される' do
        context "会員(一般人)のトップ画面が表示される" do
            before do
                get root_path
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
        context "美容師のトップ画面が表示される" do 
            before do
                get hairdresser_top_path
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
        context "aboutページが表示される" do 
            before do
                get about_path
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
        context "美容師のトップ画面が表示される" do 
            before do
                get hairdresser_top_path
            end
            it 'リクエストは200 OKとなること' do
                expect(response.status).to eq 200
            end
        end
    end
end