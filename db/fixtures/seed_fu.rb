User.seed do |s|
    s.id = 1
    s.name = "あいこ"
    s.email = "aaa@gmail.com"
    s.password = "chokichoki"
    s.sex = "女性"
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

# User.seed do |s|
#     s.id = 1
#     s.name = "ゆう"
#     s.email = "aaa@gmail.com"
#     s.password = "chokichoki"
#     s.sex = "男性"
#     s.activation_status = true
# end

# (1..100).each do |num|
#     Hairdresser.seed do |s|
#         s.id = num
#         s.name = "堀田茜#{num}"
#         s.email = "#{num}@gmail.com"
#         s.introduction = "私がどんなブサイクでも可愛くします"
#         s.address = "東京都千代田区"
#         s.shop_name = "リップス"
#         s.confirm_image = Rails.root.join("db/fixtures/images/sky.jpg").open
#         s.hairdresser_image = Rails.root.join("db/fixtures/images/sky.jpg").open
#         s.password = "chokichoki"
#         s.post_number = 1000000
#         s.sex = "女性"
#         s.shop_latitude = 35.6868981
#         s.shop_longitude = 139.7388314
#         s.activation_status = true
#         s.judge_status = true
#         if 1 <= num && num <= 10
#             s.reputation_point = 50
#         elsif 11 <= num && num <= 20
#             s.reputation_point = 45
#         elsif 21 <= num && num <= 30
#             s.reputation_point = 40
#         elsif 31 <= num && num <= 40
#             s.reputation_point = 35
#         elsif 41 <= num && num <= 50
#             s.reputation_point = 30
#         elsif 51 <= num && num <= 60
#             s.reputation_point = 25
#         elsif 61 <= num && num <= 70
#             s.reputation_point = 20
#         elsif 71 <= num && num <= 80
#             s.reputation_point = 15
#         elsif 81 <= num && num <= 90
#             s.reputation_point = 10
#         elsif 91 <= num && num <= 100
#             s.reputation_point = 5
#         end
#     end 

#     StyleImage.seed do |s|
#         s.id = num
#         s.hairdresser_id = num
#     end

#     (1..10).each do |num2| #美容師一人につきメニューを10個持っている設定
#         Menu.seed do |s|
#             s.hairdresser_id = num
#             s.name = "スタイリング#{num2}"
#             s.time = 30
#             s.explanation = "誰でもカッコよく、可愛くします。"
#             if num2 == 1 || num2 == 2
#                 s.category = "1000"
#             elsif num2 == 3 || num2 == 4
#                 s.category = "0100"
#             elsif num2 == 5 || num2 == 6
#                 s.category = "0010"
#             elsif num2 == 7 || num2 == 8
#                 s.category = "0001"
#             elsif num2 == 9 || num2 == 10
#                 s.category = "1100"
#             end
#             s.status = true
#         end
#     end

#     (1..10).each do |re_num| 
#         Reservation.seed do |s|
#             if re_num == 1 
#                 s.menu_id = 1+ 10 * (num-1)
#             elsif re_num == 2 
#                 s.menu_id = 2 + 10 * (num-1)
#             elsif re_num == 3 
#                 s.menu_id = 3 + 10 * (num-1)
#             elsif re_num == 4 
#                 s.menu_id = 4 + 10 * (num-1)
#             elsif re_num == 5 
#                 s.menu_id = 5 + 10 * (num-1)
#             elsif re_num == 6 
#                 s.menu_id = 6 + 10 * (num-1)
#             elsif re_num == 7 
#                 s.menu_id = 7 + 10 * (num-1)
#             elsif re_num == 8 
#                 s.menu_id = 8 + 10 * (num-1)
#             elsif re_num == 9 
#                 s.menu_id = 9 + 10 * (num-1)
#             elsif re_num == 10 
#                 s.menu_id = 10 + 10 * (num-1)
#             end
#             s.user_id = 1
#             s.start_time = "2020-09-07 15:30:00 +0900".to_time + re_num * 1800
#             s.status = true
#         end
#         Room.seed do |s|
#             s.id = re_num + (num-1)*10
#         end
#         Chat.seed do |s|
#             s.room_id = re_num + (num-1)*10
#             s.hairdresser_id = num
#             s.reservation_id = re_num + (num-1)*10
#             s.user_id = 1
#         end
#     end

#     (1..10).each do |num3| 
#         HairdresserComment.seed do |s|
#             s.hairdresser_id = num
#             s.user_id = 1
#             if 1 <= num && num <= 10
#                 s.rate = 5.0
#                 s.comment = "最高でした"
#             elsif 11 <= num && num <= 20
#                 s.rate = 4.5
#                 s.comment = "とても良かったです また行きたいです"
#             elsif 21 <= num && num <= 30
#                 s.rate = 4.0
#                 s.comment = "良かったです"
#             elsif 31 <= num && num <= 40
#                 s.rate = 3.5
#                 s.comment = "まずまずでした"
#             elsif 41 <= num && num <= 50
#                 s.rate = 3.0
#                 s.comment = "普通でした 可もなく不可もなくという感じでした"
#             elsif 51 <= num && num <= 60
#                 s.rate = 2.5
#                 s.comment = "自分のイメージとは違った感じになりました"
#             elsif 61 <= num && num <= 70
#                 s.rate = 2.0
#                 s.comment = "あまりおすすめしません"
#             elsif 71 <= num && num <= 80
#                 s.rate = 1.5
#                 s.comment = "鏡をみた瞬間に終わったと思いました"
#             elsif 81 <= num && num <= 90
#                 s.rate = 1.0
#                 s.comment = "絶対に行かない方がいいです 後悔します"
#             elsif 91 <= num && num <= 100
#                 s.rate = 0.5
#                 s.comment = "すべてが最悪でした"
#             end

#             if num3 == 1 
#                 s.menu_id = 1 + 10 * (num-1)
#             elsif num3 == 2 
#                 s.menu_id = 2 + 10 * (num-1)
#             elsif num3 == 3 
#                 s.menu_id = 3 + 10 * (num-1)
#             elsif num3 == 4 
#                 s.menu_id = 4 + 10 * (num-1)
#             elsif num3 == 5 
#                 s.menu_id = 5 + 10 * (num-1)
#             elsif num3 == 6 
#                 s.menu_id = 6 + 10 * (num-1)
#             elsif num3 == 7 
#                 s.menu_id = 7 + 10 * (num-1)
#             elsif num3 == 8 
#                 s.menu_id = 8 + 10 * (num-1)
#             elsif num3 == 9 
#                 s.menu_id = 9 + 10 * (num-1)
#             elsif num3 == 10 
#                 s.menu_id = 10 + 10 * (num-1)
#             end

#             s.start_time = "2020-09-07 15:30:00 +0900".to_time + num3 * 1800
#         end
#     end

    
# end




# Admin.seed do |s|
#     s.email = "aaa@gmail.com"
#     s.password_digest = "chokichoki"
# end
