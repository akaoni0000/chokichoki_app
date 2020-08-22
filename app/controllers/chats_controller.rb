class ChatsController < ApplicationController
    def user_chat
        @chats = Chat.where(user_id: @current_user.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat" #jsでfooterをdisplay_noneにする
    end

    def hairdresser_chat
        @chats = Chat.where(hairdresser_id: @current_hairdresser.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat" #jsでfooterをdisplay_noneにする
    end

    def message_create
        @chat_message = ChatMessage.new(chat_message_params)
        if @current_user.present?
            @chat_message.user_id = @current_user.id
        elsif @current_hairdresser.present?
            @chat_message.hairdresser_id = @current_hairdresser.id
        end
        @chat_message.style_images.map! {|a| a.to_i}
        if @chat_message.save
            @room = @chat_message.room
            @chat = Chat.find_by(room_id: @room.id)
            @style_image = StyleImage.find_by(hairdresser_id: @chat.hairdresser_id)
            @hair_arry = @style_image.hair_images
            @chat_messages = ChatMessage.where(room_id: @room.id)
            if @chat_messages.last(2).first.created_at.to_date != @chat_messages.last(2).last.created_at.to_date #chat_messagesテーブルの最後の二つのデータの作成日が違うかどうか
                @date = @chat_messages.last.created_at.to_date
            end
        end
    end
   
    def room
        @room = Room.find(params[:room_id])
        @chat_messages = ChatMessage.where(room_id: @room.id)
        @chat = Chat.find_by(room_id: @room.id)
        @user = @chat.user
        @hairdresser = @chat.hairdresser

        @reservation = Reservation.find(@chat.reservation_id)
        @time = @reservation.start_time
        @style_image = StyleImage.find_by(hairdresser_id: @hairdresser.id)
        @hair_arry = @style_image.hair_images

        #未読をなくす
        if @current_user.present?
            @unread_message = ChatMessage.where(room_id: @room.id, hairdresser_id: @chat.hairdresser_id, notification: false)
            if @unread_message.present?
                @unread_message.update_all(:notification => true )
            end
        elsif @current_hairdresser.present?
            @unread_message = ChatMessage.where(room_id: @room.id, user_id: @chat.user_id, notification: false)
            if @unread_message.present?
                @unread_message.update_all(:notification => true )
            end
        end
    end

    private
    def chat_message_params
        params.require(:chat_message).permit(:message, :room_id, :image, style_images:[])
    end
end
