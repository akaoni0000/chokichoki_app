class Room < ApplicationRecord
    has_secure_token :room_token

    has_many :chat_messages
end

