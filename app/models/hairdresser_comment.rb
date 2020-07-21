class HairdresserComment < ApplicationRecord
    belongs_to :hairdresser
    belongs_to :user
end
