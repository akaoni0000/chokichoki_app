class Hairdresser < ApplicationRecord
    
    has_secure_password
    attachment :confirm_image 

end
