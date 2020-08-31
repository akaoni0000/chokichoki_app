# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# users = User.create([{name: "hanako"}, {name: "misa"}])
# #admins = Admin.create([{email: "hanako"}])
# (1..2).each do |n|
#     Hairdresser.create!(
#       email: "email#{n}@example.com",
#       name: "#{n}名前",
#       profile_photo: open("#{Rails.root}/db/fixtures/test.JPG"),
#       profile:"#{n}test",
#       password_digest:"#{n}test",
#       industry:"#{n}test",
#       occupation:"#{n}test",
#       corporation_name:"#{n}test"
#     )
# end
  
Admin.create!(:email => 'aaa@gmail.com', :password_digest => "chokichoki")

User.create!(:name => "えみたん", :email => "abc@gmail.com", :password => "chokichoki", :sex => "女性")
User.create!(:name => "えみりん", :email => "bbb@gmail.com", :password => "chokichoki", :sex => "女性")