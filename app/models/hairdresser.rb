class Hairdresser < ApplicationRecord

    attachment :confirm_image 
    has_secure_password
    has_many :hairdresser_comments
    has_many :style_images
    

   


end
