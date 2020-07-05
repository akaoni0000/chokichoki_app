class User < ApplicationRecord
    has_secure_password    #presenceのバリデーションも兼ねている
    validates :name, presence: true
end
