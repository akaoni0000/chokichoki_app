class Menu < ApplicationRecord
    attachment :menu_image 
    has_many :reservations
    belongs_to :hairdressers, optional: true     #rollback transaction対策

end
