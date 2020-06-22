class Reservation < ApplicationRecord
    validates :start_time, uniqueness: true
end
