class HairdresserComment < ApplicationRecord
    validates :rate, presence: true

    belongs_to :hairdresser
    belongs_to :user
    belongs_to :menu
end
