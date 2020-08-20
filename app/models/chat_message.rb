class ChatMessage < ApplicationRecord

    validate :prevent_all_blank # 保存時に カスタムバリデーション発動

    # カスタムバリデーションメソッド
    def prevent_all_blank
        if message == "" && image.blank? && style_images.blank? # バリデーションの条件
            errors.add(:all_blank, "fda") #これは必ずいる :all_blankは自由 エラーメッセージを追加しないとダメ
        end
    end

    #配列として保存する時はこの記述がいる
    serialize :style_images, Array
    #gem refile を使う時
    attachment :image

    #refileを扱うときはidは絶対いらない idを入れると不具合起こる
end
