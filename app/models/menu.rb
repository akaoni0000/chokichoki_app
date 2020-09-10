class Menu < ApplicationRecord
    attr_accessor :menu_update_status

    #バリデーション
    validates :name, length: { in: 2..12 }
    validates :time, presence: true
    validates :explanation, length: { in: 10..160 }
    validates :category, format: { without: /0000/ }
    validate :name_only # 保存時に カスタムバリデーション発動

    # カスタムバリデーションメソッド
    def name_only
        if self.menu_update_status.blank? && Menu.where(hairdresser_id: self.hairdresser_id, name: self.name).present?
            errors.add(:name_only, "同じ美容師で同じ名前のメニューはダメ")
        end
    end

    #gem refile を使う時
    attachment :menu_image 

    #モデル関連付け
    has_many :reservations, dependent: :destroy
    has_many :cancel_reservations, dependent: :destroy
    has_many :hairdresser_comments, dependent: :destroy
    belongs_to :hairdresser, optional: true     #rollback transaction対策

end
