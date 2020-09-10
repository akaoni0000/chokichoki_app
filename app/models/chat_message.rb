class ChatMessage < ApplicationRecord

    validate :prevent_all_blank # 保存時に カスタムバリデーション発動

    # カスタムバリデーションメソッド
    def prevent_all_blank
        if (message == nil || message == "") && image.blank? && style_images.blank? # バリデーションの条件
            errors.add(:all_blank, "全部空はダメ") #これは必ずいる :all_blankは自由 エラーメッセージを追加しないとダメ
        end
    end

    #配列として保存する時はこの記述がいる
    serialize :style_images, Array

    #gem refile を使う時 #refileを扱うときはidは絶対いらない idを入れると不具合起こる
    attachment :image
    
    #関連付け
    belongs_to :room
end
