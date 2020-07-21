class User < ApplicationRecord
    has_secure_password    #presenceのバリデーションも兼ねている
    validates :name, presence: true
    #has_many :reservations
    has_many :hairdresser_comments
end
