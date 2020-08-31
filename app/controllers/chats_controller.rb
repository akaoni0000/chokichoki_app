class ChatsController < ApplicationController
    def user_chat
        @chats = Chat.where(user_id: @current_user.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat" #jsでfooterをdisplay_noneにする footerがあるとスクロールが入って邪魔
    end

    def hairdresser_chat
        @chats = Chat.where(hairdresser_id: @current_hairdresser.id)
        @chat_message = ChatMessage.new
        gon.chat = "chat" #jsでfooterをdisplay_noneにする footerがあるとスクロールが入って邪魔
    end

    def message_create
        @chat_message = ChatMessage.new(chat_message_params)
        @chat_message.room_id = session[:room_id]
        if @current_user.present?
            @chat_message.user_id = @current_user.id
        elsif @current_hairdresser.present?
            @chat_message.hairdresser_id = @current_hairdresser.id
        end
        @chat_message.style_images.map! {|a| a.to_i} #文字列を数値に変える style_imagesは配列のカラムである 例["1", "1"]
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
   
    def room #チャットのviewの左のルームのどれかをクリックしたらここにくる
        @room = Room.find(params[:room_id])
        session[:room_id] = params[:room_id]
        @chat_messages = ChatMessage.where(room_id: @room.id)
        if @chat_messages.present? 
            @last_message = @chat_messages.last
        end
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
        
        #メッセージ送信フォームで使う
        @chat_message = ChatMessage.new

    end

    def notification #ajaxで送られてくる
        binding.pry
        @room = Room.find_by(room_token: params[:room_token])
        @unread_message = ChatMessage.find_by(room_id: @room.id, notification: false)
        @unread_message.notification = true
        @unread_message.save

        if @unread_message.user_id.present? 
            @user_or_hairdresser = "user"
        elsif @unread_message.hairdresser_id.present?
            @user_or_hairdresser = "hairdresser"
        end
        @room_token = @room.room_token

        data = {"user_or_hairdresser" => @user_or_hairdresser, "room_token" => @room_token}
        RoomChannel.notice(data)
    end

    def chat_room_search
        @keyword = params[:search_room]
        @keyword = @keyword.tr('　+',' +') #全角スペースを半角スペースにする
        @keyword.strip! #スペースを削除
        if @current_user.present? 
            @hairdressers = Hairdresser.where(['name LIKE ?', "%#{@keyword}%"])
            @chats = @hairdressers.map {|a| Chat.where(user_id: @current_user.id, hairdresser_id: a.id)}
            @chats.flatten!
            @chat_message = ChatMessage.new
            render "chats/user_chat"
        elsif @current_hairdresser.present?
            @users = User.where(['name LIKE ?', "%#{@keyword}%"])
            @chats = @users.map {|a| Chat.where(user_id: a.id, hairdresser_id: @current_hairdresser.id)}
            @chats.flatten!
            @chat_message = ChatMessage.new
            render "chats/hairdresser_chat"
        end
    end

    private
    def chat_message_params
        params.require(:chat_message).permit(:message, :image, style_images:[])
    end
end
