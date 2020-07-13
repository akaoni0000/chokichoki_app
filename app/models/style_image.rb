class StyleImage < ApplicationRecord
    
    mount_uploaders :hair_images, ImagesUploader
    serialize :hair_images, JSON
    belongs_to :hairdresser
    
end
