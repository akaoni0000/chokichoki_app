class NoticesController < ApplicationController
    def notice_message_modal
        @room = Room.find_by(room_token: params[:data][:room_token])
        if params[:data][:user_or_hairdresser] == "user" #送信先がuserなので送信元はhairdresser 自分はuser
            @hairdresser = Chat.find_by(room_id: @room.id).hairdresser

            @room_id_arry = @hairdresser.chats.map {|chat| chat.room_id}
            @message = @room_id_arry.map {|room_id| ChatMessage.where(room_id: room_id, user_id: nil, notification: false)}
            @message.flatten!
            @unread_number = @message.length
        elsif params[:data][:user_or_hairdresser] == "hairdresser" #送信先がhairdresserなので送信元はuser 自分はuser
            @user = Chat.find_by(room_id: @room.id).user

            @room_id_arry = @user.chats.map {|chat| chat.room_id}
            @message = @room_id_arry.map {|room_id| ChatMessage.where(room_id: room_id, hairdresser_id: nil, notification: false)}
            @message.flatten!
            @unread_number = @message.length
        end
        @message = params[:data][:message]
    end

    def notice_reservation_modal
        @reservation = Reservation.find_by(reservation_token: params[:data][:reservation_token])
        @time = @reservation.start_time
        @user = User.find(@reservation.user_id)
        @hairdresser = @reservation.menu.hairdresser

        @notice_reservations_number = @hairdresser.reservations.where.not(notification_status: true, user_id: nil).length
        @cancel_number = CancelReservation.where(hairdresser_id: @hairdresser.id, notification_status: false).length
    end
    
    def notice_cancel_modal
        @cancel = CancelReservation.find_by(reservation_token: params[:data][:reservation_token])
        @time = @cancel.start_time
        @user = @cancel.user
        @hairdresser = @cancel.menu.hairdresser
        
        @notice_reservations_number = @hairdresser.reservations.where.not(notification_status: true, user_id: nil).length
        @cancel_number = CancelReservation.where(hairdresser_id: @hairdresser.id, notification_status: false).length
        
    end
end
