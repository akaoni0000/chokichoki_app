require 'rails_helper'

RSpec.describe "StyleImageモデルのテスト", type: :model do
    before do
        create(:hairdresser)
    end
    let(:style_image) { create(:style_image) }
    it "データが正しく保存される" do
        expect(style_image.valid?).to eq true;
    end
end
    