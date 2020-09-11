class HairdresserComment < ApplicationRecord
    validates :rate, presence: true #デフォルトで0.0が入る

    belongs_to :hairdresser
    belongs_to :user
    belongs_to :menu
end
