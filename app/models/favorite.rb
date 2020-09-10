class Favorite < ApplicationRecord
    #モデルの関連付け
    belongs_to :user
    belongs_to :hairdresser 
end
