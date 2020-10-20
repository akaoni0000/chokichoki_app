FactoryBot.define do
    factory :reservation do 
        id {1}
        menu_id {1}
        user_id {1}
        start_time {(Date.today + 1).to_time + 3600*9}
        reservation_token {SecureRandom.urlsafe_base64}
    end
end