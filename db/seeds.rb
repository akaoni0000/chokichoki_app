# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# users = User.create([{name: "hanako"}, {name: "misa"}])
# admins = Admin.create([{email: "hanako"}])
# (1..2).each do |n|
#     Hairdresser.create!(
#       email: "email#{n}@example.com",
#       name: "#{n}名前",
#       confirm_image: open("#{Rails.root}/db/fixtures/test.JPG"),
#       introduction:"#{n}test",
#       password_digest:"#{n}test",
#       industry:"#{n}test",
#       occupation:"#{n}test",
#       corporation_name:"#{n}test"
#     )
# end

#adminとユーザーを作る
# Admin.create!(:email => 'aaa@gmail.com', :password => "chokichoki", :password_confirmation => "chokichoki")
# User.create!(:name => "テスト", :email => "1@gmail.com", :password => "chokichoki", :sex => "男性", :activation_status => true)
# User.create!(:name => "テスト2", :email => "2@gmail.com", :password => "chokichoki", :sex => "女性", :activation_status => true)
# User.create!(:name => "テスト3", :email => "3@gmail.com", :password => "chokichoki", :sex => "女性", :activation_status => true)

# image_path = File.join(Rails.root, "app/assets/images/gaaa.png")
# image = File.open(image_path, 'rb').read
# Rails.root.join(image_path("gaaa.png")).open
# Hairdresser.create!(:name => "あああ", :email => "aaa@gmail.com", :password => "chokichoki", :sex => "男性", :confirm_image => open("#{Rails.root}/app/assets/gaaa.png"), :hairdresser_image => "", :shop_name => "リップス", :post_number => 1000000, :address => "東京都千代田区", :reject_status => nil, :shop_latitude => 1.0, :shop_longitude => 1.0, :activation_status => true, :judge_status => true)



#ここからテストデータ
Admin.create!(:email => 'aaa@gmail.com', :password => "chokichoki", :password_confirmation => "chokichoki")
User.create!(:name => "テスト0", :email => "0@gmail.com", :password => "chokichoki", :sex => "女性", :activation_status => true)
User.create!(:name => "テスト1", :email => "1@gmail.com", :password => "chokichoki", :sex => "男性", :activation_status => true)
User.create!(:name => "テスト2", :email => "2@gmail.com", :password => "chokichoki", :sex => "女性", :activation_status => true)

(0..15).each do |n|
  reputation_point = n % 2 == 0 ? 4.5 : 5.0
  Hairdresser.create!(
    email: "#{n}@gmail.com",
    name: "テスト美容師#{n}",
    introduction: "よろしくお願いします",
    address: "神奈川県横浜市",
    shop_name: "hoge#{n}美容室",
    confirm_image: open("#{Rails.root}/app/assets/images/human#{n}.jpg"),
    hairdresser_image: open("#{Rails.root}/app/assets/images/human#{n}.jpg"),
    password: "chokichoki",
    post_number: "2230064",
    shop_latitude: 3.3,
    shop_longitude: 3.3,
    sex: "男性",
    #reputation_point: reputation_point,
    activation_status: true,
    judge_status: true
  )

  StyleImage.create!(
    hairdresser_id: Hairdresser.find_by(email: "#{n}@gmail.com").id
  )

  Menu.create!(
    hairdresser_id: Hairdresser.find_by(email: "#{n}@gmail.com").id,
    name: "テスト",
    time: 60,
    explanation: "テストテストテストテストテストテストテストテストテストテスト",
    category: "1111",
    status: true
  )

  HairdresserComment.create!(
    hairdresser_id: Hairdresser.find_by(email:"#{n%5}@gmail.com").id,
    user_id: User.find_by(email:"#{n%3}@gmail.com").id,
    comment: "テストテストテストテストテストテストテストテストテスト",
    menu_id: Hairdresser.find_by(email:"#{n}@gmail.com").menus[0].id,
    rate: reputation_point,
    start_time: DateTime.new(2024, 1, 1, 12, 0, 0)
  )
end


(0..15).each do |n|
  hairdresser = Hairdresser.find_by(email: "#{n}@gmail.com")
  total = hairdresser.hairdresser_comments.sum { |comment| comment['rate'] }
  hairdresser.update!(reputation_point: total)
end
