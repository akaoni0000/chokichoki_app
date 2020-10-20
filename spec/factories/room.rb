FactoryBot.define do
    factory :room do 
        id {1}
        room_token {SecureRandom.urlsafe_base64}
    end
end