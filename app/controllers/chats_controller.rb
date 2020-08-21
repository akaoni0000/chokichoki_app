class ChatsController < ApplicationController
    def user_chat
        @chats = Chat.where(user_id: @current_user.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat"
    end

    def hairdresser_chat
        @chats = Chat.where(hairdresser_id: @current_hairdresser.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat"
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
            @room_id = @chat_message.room_id
            @chat = Chat.find_by(room_id: @room_id)
            @style_image = StyleImage.find_by(hairdresser_id: @chat.hairdresser_id)
            @hair_arry = @style_image.hair_images
            @chat_messages = ChatMessage.where(room_id: @room_id)
            if @chat_messages.last(2).first.created_at.to_date != @chat_messages.last(2).last.created_at.to_date
                @date = @chat_messages.last(2).last.created_at.to_date
            end
        end
    end
   
    def room
        @chat_messages = ChatMessage.where(room_id: params[:room_id])
        @room_id = params[:room_id]
        @user = Chat.find_by(room_id: @room_id).user
        @hairdresser = Chat.find_by(room_id: @room_id).hairdresser
        @style_image = StyleImage.find_by(hairdresser_id: @hairdresser.id)
        @hair_arry = @style_image.hair_images
    end

    private
    def chat_message_params
        params.require(:chat_message).permit(:message, :room_id, :image, style_images:[])
    end
end
