User.seed do |s|
    s.id = 1
    s.name = "あいこ"
    s.email = "aaa@gmail.com"
    s.password = "chokichoki"
    s.sex = "男性"
    s.activation_status = true
    s.activation_deadline_at = "2020-09-07 15:30:00 +0900".to_time
end

Hairdresser.seed do |s|
    s.id = 1
    s.name = "アンジェラ"
    s.email = "aaa@gmail.com"
    s.introduction = "私が絶対に可愛くします"
    s.address = "東京都千代田区"
    s.shop_name = "リップス"
    s.confirm_image = Rails.root.join("db/fixtures/images/sky.jpg").open
    s.hairdresser_image = Rails.root.join("db/fixtures/images/sky.jpg").open
    s.password = "chokichoki"
    s.post_number = 1000000
    s.sex = "女性"
    s.shop_latitude = 35.6868981
    s.shop_longitude = 139.7388314
    s.activation_status = true
    s.judge_status = true
end

StyleImage.seed do |s|
    s.id = 1
    s.hairdresser_id = 1
end

Admin.seed do |s|
    s.id = 1
    s.email = "aaa@gmail.com"
    s.password = "chokichoki"
end
