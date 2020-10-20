FactoryBot.define do
    factory :cancel_reservation do
        id {1}
        user_id {1}
        menu_id {1}
        hairdresser_id {1}
        start_time { Time.local(2020,1,1,9) }
        reservation_token {SecureRandom.urlsafe_base64}
    end
end