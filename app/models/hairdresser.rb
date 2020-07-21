class Hairdresser < ApplicationRecord

    attachment :confirm_image 
    attachment :hairdresser_image 
    has_secure_password
    has_many :hairdresser_comments
    has_many :style_images

    has_many :menus
    has_many :reservations, through: :menus

   


end
