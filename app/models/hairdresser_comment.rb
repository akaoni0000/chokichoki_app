class HairdresserComment < ApplicationRecord
    validates :rate, presence: true #デフォルトで0.0が入る
    validate :prevent_0, on: :update

    def prevent_0
        if self.rate.blank? || self.rate == 0.0
            errors.add(:rate_validate, "updateのときは数字をいれる") 
        end
    end

    belongs_to :hairdresser
    belongs_to :user
    belongs_to :menu
end
