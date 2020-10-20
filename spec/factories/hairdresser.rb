FactoryBot.define do
    factory :hairdresser do
        id {1}
        name {"アンジェラ"}
        email {"aaa@gmail.com"}
        address {"東京都千代田区"}
        shop_name {"チョキチョキ"}
        confirm_image {Rails.root.join("db/fixtures/images/sky.jpg").open}
        password {"chokichoki"}
        post_number {1000000}
        sex {"女性"}
        shop_latitude {35.6868981}
        shop_longitude {139.7388314}
        activation_status {true}
        introduction {"よろしくお願いします"}
        judge_status {true}
    end
end