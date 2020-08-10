class Menu < ApplicationRecord

    #バリデーション
    validates :name, length: { in: 2..12 }
    validates :time, presence: true
    validates :explanation, length: { in: 10..160 }
    validates :category, format: { without: /0000/ }

    #gem refile を使う時
    attachment :menu_image 

    #モデル関連付け
    has_many :reservations, dependent: :destroy
    has_many :cancel_reservations, dependent: :destroy
    belongs_to :hairdresser, optional: true     #rollback transaction対策

end
