class RoomChannel < ApplicationCable::Channel
    def subscribed
        stream_from "room_channel" 
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end

    def self.talk(data)
        ActionCable.server.broadcast 'room_channel', room_token: data[:room_token], user_or_hairdresser: data[:user_or_hairdresser], digest: data[:digest], message: data[:message], time: data[:time], type: "メッセージ送信"
    end

    def self.notice(data)
        ActionCable.server.broadcast "room_channel", room_token: data[:room_token], user_or_hairdresser: data[:user_or_hairdresser], digest: data[:digest], type: "既読をつける"
    end

    def self.notice_reservation(data)
        ActionCable.server.broadcast "room_channel", reservation_token: data[:reservation_token], digest: data[:digest], type: "予約が入ったことを知らせる"
    end
    
    def self.notice_cancel(data)
        ActionCable.server.broadcast "room_channel", reservation_token: data[:reservation_token], digest: data[:digest], type: "キャンセルが入ったことを知らせる"
    end

end
