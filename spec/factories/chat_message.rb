FactoryBot.define do
    factory :chat_message do
        id {1}
        user_id {1}
        hairdresser_id {1}
        room_id {1}
        message {"よろしくお願いします"}
    end
end