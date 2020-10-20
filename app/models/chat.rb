class Chat < ApplicationRecord
    belongs_to :hairdresser
    belongs_to :user

    validates :room_id, presence: { message: "room_idがありません" }
    validates :reservation_id, presence: { message: "reservation_idがありません" }
end
