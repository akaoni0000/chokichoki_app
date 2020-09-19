class ChatsController < ApplicationController
    include AjaxHelper 
    def user_chat
        @chats = Chat.where(user_id: @current_user.id)
        @chat_message = ChatMessage.new
        find_last_message
        gon.chat = "chat" #jsでfooterをdisplay_noneにする footerがあるとスクロールが入って邪魔
    end

    def hairdresser_chat
        @chats = Chat.where(hairdresser_id: @current_hairdresser.id)
        @chat_message = ChatMessage.new
        find_last_message
        gon.chat = "chat" #jsでfooterをdisplay_noneにする footerがあるとスクロールが入って邪魔
    end
   
    def room #チャットのviewの左のルームのどれかをクリックしたらここにくる
        if @current_user.present?
            @chats = Chat.where(room_id: params[:room_id], user_id: @current_user.id)
        elsif @current_hairdresser.present?
            @chats = Chat.where(room_id: params[:room_id], hairdresser_id: @current_hairdresser.id)
        end
        if @chats.present? #フロントで引数を変更された時の対策
            @room = Room.find(params[:room_id]) #どのルームか特定する
            session[:room_id] = params[:room_id] #ルームをクリックした瞬間にsessionを発動

            @chat = Chat.find_by(room_id: @room.id) #誰と誰がその部屋の番号にいるのかを取得
            @user = @chat.user
            @hairdresser = @chat.hairdresser

            @reservation = Reservation.find(@chat.reservation_id) #予約を取得
            @time = @reservation.start_time #予約の時間(施術開始時刻)を取得
            @style_image = StyleImage.find_by(hairdresser_id: @hairdresser.id) #そのルームにいる美容師のヘアカタログの画像のレコードを取得
            @hair_arry = @style_image.hair_images #そのカラムを取得

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
            
            @chat_message = ChatMessage.new #メッセージ送信フォームで使う
            @chat_messages = ChatMessage.where(room_id: @room.id) #そのルームのメッセージを取得
            if @chat_messages.present? #メッセージが存在したら
                @last_message = @chat_messages.last #そのルームに入った瞬間相手に既読をつけるために使う
                if @current_user.present? && @last_message.hairdresser_id.present?
                    data = {room_token: @room.room_token, user_or_hairdresser: "hairdresser", digest: @hairdresser.activation_digest}
                    RoomChannel.notice(data)
                elsif @current_hairdresser.present? && @last_message.user_id.present?
                    data = {room_token: @room.room_token, user_or_hairdresser: "user", digest: @user.activation_digest}
                    RoomChannel.notice(data)
                end
            end
        else
            flash[:notice_red] = "エラーが発生しました"
            if @current_user.present?
                respond_to do |format|
                    format.js { render ajax_redirect_to(root_path) }
                end
            elsif @current_hairdresser.present?
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_path(@current_hairdresser.id)) }
                end
            end
        end
    end

    def message_create
        @chat_message = ChatMessage.new(chat_message_params)
        @chat_message.room_id = session[:room_id] #このセッションはルームをクリックした時に発行される
        @chat = Chat.find_by(room_id: session[:room_id])
        if @chat.present?
            if @current_user.present?
                @chat_message.user_id = @current_user.id
                @user_or_hairdresser = "hairdresser" #メッセージを送る相手
                @digest = @chat.hairdresser.activation_digest
            elsif @current_hairdresser.present?
                @chat_message.hairdresser_id = @current_hairdresser.id
                @user_or_hairdresser = "user" #メッセージを送る相手
                @digest = @chat.user.activation_digest
            end
            @chat_message.style_images.map! {|a| a.to_i} #文字列を数値に変える style_imagesは配列のカラムである 例["1", "1"]
            if @chat_message.save #何もparamsで送られて来なかった時は保存されない
                @room = Room.find(@chat.room_id)
                @style_image = StyleImage.find_by(hairdresser_id: @chat.hairdresser_id) #美容師の
                @hair_arry = @style_image.hair_images 
                @chat_messages = ChatMessage.where(room_id: @chat.room_id)
                if @chat_messages.last(2).first.created_at.to_date != @chat_messages.last(2).last.created_at.to_date #chat_messagesテーブルの最後の二つのデータの作成日が違うかどうか
                    @date = @chat_messages.last.created_at.to_date
                end
                @time = "#{@chat_message.created_at.to_time.hour}:#{@chat_message.created_at.to_time.strftime("%Y-%m-%d %H:%M:%S").strip[14, 2]}"
                data = {room_token: @room.room_token, user_or_hairdresser: @user_or_hairdresser, digest: @digest, message: @chat_message.message, time: @time}
                RoomChannel.talk(data)
            end
        else
            flash[:notice_red] = "エラーが発生しました"
            if @current_user.present?
                respond_to do |format|
                    format.js { render ajax_redirect_to(root_path) }
                end
            elsif @current_hairdresser.present?
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_path(@current_hairdresser.id)) }
                end
            end
        end
    end

    def receive_message 
        @room = Room.find_by(room_token: params[:data][:room_token])
        @chat = Chat.find_by(room_id: @room.id)
        if params[:data][:user_or_hairdresser] == "user" #メッセージを送信した人がuserに送ったので相手はhairdresser
            @hairdresser = @chat.hairdresser
            data = {room_token: @room.room_token, user_or_hairdresser: "hairdresser", digest: @hairdresser.activation_digest}
        end
        if params[:data][:user_or_hairdresser] == "hairdresser" #メッセージを送信した人がhairdresserに送ったので相手はuser
            @user = @chat.user
            data = {room_token: @room.room_token, user_or_hairdresser: "user", digest: @user.activation_digest}
        end
        @style_image = StyleImage.find_by(hairdresser_id: @chat.hairdresser_id) #美容師の
        @hair_arry = @style_image.hair_images 
        @chat_messages = ChatMessage.where(room_id: @room.id)
        if @chat_messages.last(2).first.created_at.to_date != @chat_messages.last(2).last.created_at.to_date #chat_messagesテーブルの最後の二つのデータの作成日が違うかどうか
            @date = @chat_messages.last.created_at.to_date
        end
        @chat_message = ChatMessage.where(room_id: @room.id).last
        @chat_message.notification = true
        @chat_message.save

        @time = "#{@chat_message.created_at.to_time.hour}:#{@chat_message.created_at.to_time.strftime("%Y-%m-%d %H:%M:%S").strip[14, 2]}"
        
        RoomChannel.notice(data)
    end

    def chat_room_search #post 検索フォームから値が送られてくる
        @keyword = params[:search_room]
        @keyword = @keyword.tr('　+',' +') #全角スペースを半角スペースにする
        @keyword.strip! #スペースを削除
        if @current_user.present? 
            @hairdressers = Hairdresser.where(['name LIKE ?', "%#{@keyword}%"])
            @chats = @hairdressers.map {|a| Chat.where(user_id: @current_user.id, hairdresser_id: a.id)}
        elsif @current_hairdresser.present?
            @users = User.where(['name LIKE ?', "%#{@keyword}%"])
            @chats = @users.map {|a| Chat.where(user_id: a.id, hairdresser_id: @current_hairdresser.id)}
        end
        @chats.flatten!
        find_last_message
        @chat_message = ChatMessage.new
        gon.chat = "chat"
        render "chats/user_chat"
    end

    def find_last_message #一番最後に話をしたルームを見つけて一番上に持ってくる インスタンスメソッド
        @room_id_arry = @chats.map {|chat| chat.room_id}
        i = 1
        @room_id_arry.each do |room_id|
            if i == 1
                @last_message = ChatMessage.order(created_at: "DESC").find_by(room_id: room_id)
                if @last_message.blank?
                    i = 0
                end
            else 
                @new_last_message = ChatMessage.order(created_at: "DESC").find_by(room_id: room_id)
                if @new_last_message.present? && @last_message.created_at < @new_last_message.created_at
                    @last_message = @new_last_message
                end
            end
            i += 1
        end
        if @last_message.present?
            gon.room_token = @last_message.room.room_token #jsで一番最後のメッセージがある部屋を先頭に持ってくる
        end
    end

    private
    def chat_message_params
        params.require(:chat_message).permit(:message, :image, style_images:[])
    end
end
