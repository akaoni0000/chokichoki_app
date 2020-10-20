require 'rails_helper'

RSpec.describe "homeコントローラのテスト", type: :request do
    it 'userのトップ画面を表示' do
        get root_path
        expect(response.status).to eq 200;
    end
    it 'hairdresserのトップ画面を表示' do
        get hairdresser_top_path
        expect(response.status).to eq 200;
    end
    it 'aboutページを表示「' do
        get about_path
        expect(response.status).to eq 200;
    end
    it "urlの有効期限が切れているページを表示" do
        get deadline_path
        expect(response.status).to eq 200;
    end
end