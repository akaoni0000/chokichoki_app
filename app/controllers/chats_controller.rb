class ChatsController < ApplicationController
    def user_chat
        @chats = Chat.where(user_id: @current_user.id)
    end

    def hairdresser_chat
        @chats = Chat.where(hairdresser_id: @current_hairdresser.id)
    end

    def message_create
        @chat_message = ChatMessage.new(chat_message_params)
        if @current_user.present?
            @chat_message.user_id = @current_user.id
        elsif @current_hairdresser.present?
            @chat_message.hairdresser_id = @current_hairdresser.id
        end
        @chat_message.save
        @room_id = @chat_message.room_id
    end
   
    # def message_create
    #     @hairdresser_chat = HairdresserChat.new(hairdresser_chat_params)
    #     @hairdresser_chat.hairdresser_id = @current_hairdresser.id
    #     @hairdresser_chat.speaker = "hairdresser"
    #     @hairdresser_chat.save
    #     @room_id = @hairdresser_chat.room_id
    # end

    def room
        @chat_messages = ChatMessage.where(room_id: params[:room_id])
        @room_id = params[:room_id]
    end

    private
    # def user_chat_params
    #     params.permit(:message, :room_id)
    # end

    # def hairdresser_chat_params
    #     params.permit(:message, :room_id)
    # end

    def chat_message_params
        params.permit(:message, :room_id)
    end
end
