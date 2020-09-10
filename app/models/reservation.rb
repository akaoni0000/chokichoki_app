class Reservation < ApplicationRecord
    has_secure_token :reservation_token

    validate :start_time_validation # 保存時に カスタムバリデーション発動
    validate :start_time_validation2, on: :create
    validate :start_time_validation3 

    # カスタムバリデーションメソッド
    def start_time_validation
        if start_time.to_i % 1800 != 0 || start_time <= Time.now || Time.now + 3600*24*90 <= start_time
            errors.add(:time_validation_30, "時間は30分単位で今の時刻から後の時間と90日以内じゃないとだめだよ") 
        end
    end

    def start_time_validation2
        @reservation = Reservation.find_by(menu_id: menu_id, start_time: start_time)
        if @reservation.present? #すでに予約が入っているとき 普通に操作していたら発動しないが、フロントで引数を変更されると起こる
            errors.add(:taken_validation, "同じメニューで同じ時間はダメだよ") 
        end
    end

    def start_time_validation3
        if ( 0 <= start_time.hour && start_time.hour <= 5 ) 
            errors.add(:time_invalid, "6時から23時30分の間だよ") 
        end
    end

    #関連付け
    belongs_to :menu, optional: true     #rollback transaction対策
    belongs_to :hairdresser, optional: true     #rollback transaction対策
    belongs_to :user, optional: true  #関連づけるとreservationsテーブルのデータを保存するときuser_idも必ず保存しなければならない
    has_many :chats, dependent: :destroy

end
