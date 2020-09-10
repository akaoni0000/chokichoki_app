class Batch::DataReset
    def self.user_data_reset
        @users = User.select {|user| Time.now < user.activation_deadline_at && user.activation_status == false} 
        @users.map! {|user| user.id}
        User.where(id: @users).destroy_all
        p "メール認証の有効期限が切れた会員データを全て削除しました"
    end

    def self.hairdresser_data_reset
        @hairdressers = Hairdresser.select {|hairdresser| Time.now < hairdresser.activation_deadline_at && hairdresser.activation_status == false} 
        @hairdressers.map! {|hairdresser| hairdresser.id}
        Hairdresser.where(id: @hairdressers).destroy_all
        p "メール認証の有効期限が切れた美容師データを全て削除しました"
    end

    def self.reject_hairdresser_data_reset
        @hairdressers = Hairdresser.select {|hairdresser| hairdresser.created_at + 3600 * 24 * 3 < Time.now && hairdresser.reject_status != nil && hairdresser.activation_status == true}
        @hairdressers.map! {|hairdresser| hairdresser.id}
        Hairdresser.where(id: @hairdressers).destroy_all
        p "登録審査に落ちた美容師データを全て削除しました"
    end

    def self.reservation_data_reset
        @reservations = Reservation.select {|reservation| reservation.start_time < Time.now && reservation.user_id == nil}
        @reservations.map! {|reservation| reservation.id}
        Reservation.where(id: @reservations).destroy_all
        p "必要のない予約データを全て削除しました"
    end

    def self.chat_data_reset
        @reservations = Reservation.select {|reservation| reservation.start_time + reservation.menu.time * 60 < Time.now && reservation.user_id != nil}
        @reservations.map! {|reservation| reservation.id}
        @chat = Chat.where(reservation_id: @reservations)
        @room_id = @chat.map {|chat| chat.room_id}
        Chat.where(room_id: @room_id).destroy_all
        ChatMessage.where(room_id: @room_id).destroy_all
        p "チャットルームを削除しました"
    end
end