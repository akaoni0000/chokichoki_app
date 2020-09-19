class Batch::DataReset
    #6時間ごと
    def self.user_data_reset
        @users = User.select {|user| user.activation_deadline_at < Time.now && user.activation_status == false} 
        if @users.present?
            @users.map! {|user| user.id}
            User.where(id: @users).destroy_all
            p "メール認証の有効期限が切れた会員データを全て削除しました"
        else
            p "会員データをチェックしました"
        end
    end

    #7時間ごと
    def self.hairdresser_data_reset
        @hairdressers = Hairdresser.select {|hairdresser| hairdresser.activation_deadline_at < Time.now && hairdresser.activation_status == false} 
        if @hairdressers.present?
            @hairdressers.map! {|hairdresser| hairdresser.id}
            Hairdresser.where(id: @hairdressers).destroy_all
            p "メール認証の有効期限が切れた美容師データを全て削除しました"
        else
            p "美容師データをチェックしました"
        end
    end

    #12時間ごと
    def self.reject_hairdresser_data_reset
        @hairdressers = Hairdresser.select {|hairdresser| hairdresser.created_at + 3600 * 24 * 3 < Time.now && hairdresser.reject_status != nil && hairdresser.activation_status == true}
        if @hairdressers.present?
            @hairdressers.map! {|hairdresser| hairdresser.id}
            Hairdresser.where(id: @hairdressers).destroy_all
            p "登録審査に落ちた美容師データを全て削除しました"
        else
            p "登録審査に落ちた美容師データをチェックしました"
        end
    end

    #24時間ごと
    def self.reservation_data_reset
        @reservations = Reservation.select {|reservation| reservation.start_time < Time.now && reservation.user_id == nil}
        if @reservations.present?
            @reservations.map! {|reservation| reservation.id}
            Reservation.where(id: @reservations).destroy_all
            p "必要のない予約データを全て削除しました"
        else
            p "予約データを参照しました"
        end
    end

    #15時間ごと
    def self.chat_data_reset
        @reservations = Reservation.select {|reservation| reservation.start_time + reservation.menu.time * 60 < Time.now && reservation.user_id != nil}
        if @reservations.present?
            @reservations.map! {|reservation| reservation.id}
            @chat = Chat.where(reservation_id: @reservations)
            @room_id = @chat.map {|chat| chat.room_id}
            Chat.where(room_id: @room_id).destroy_all
            ChatMessage.where(room_id: @room_id).destroy_all
            p "チャットルームを削除しました"
        else
            p "チャットルームを参照しました"
        end
    end
end