class Users::ReservationsController < ApplicationController

    include AjaxHelper #非同期からredirect_toするための記述

    def index #userの予約一覧
        @reservations = Reservation.where(user_id: @current_user.id).order(start_time: :asc)
        @date_arry = @reservations.all.pluck(:start_time).map {|a| a.to_date}
        @date_arry.uniq!
        @date_number = @date_arry.length
    end

    def set_week_calendar_reservation #週間カレンダーで予約
        #カレンダーの週を変える
        if params[:option] == "last"
            @standard_day = Date.new(params[:day][0,4].to_i, params[:day][5,2].to_i, params[:day][8,2].to_i)
            @standard_day -= 7
        elsif params[:option] == "next"
            @standard_day = Date.new(params[:day][0,4].to_i, params[:day][5,2].to_i, params[:day][8,2].to_i)
            @standard_day += 7
        elsif params[:standard_day].present?
            @standard_day = Date.new(params[:standard_day][0,4].to_i, params[:standard_day][5,2].to_i, params[:standard_day][8,2].to_i)
        else
            @standard_day = Date.today 
        end

        if params[:win_height].present?
            gon.win_height = params[:win_height].to_i
        end

        #テーブルの真ん中上の年月のviewを整えるのに使う
        @diff = (@standard_day.end_of_month - @standard_day).to_i
        
        @clock_arry = ["06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:30", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00","15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "23:30"]
        
        #配列を作成
        for i in 1..14 do 
            if i == 1 
                @key_time = Time.local(@standard_day.year, @standard_day.month, @standard_day.day) + 3600*6   #秒で計算している 3600は一時間
                @time_arry = @key_time.to_i.step( (Time.local(@standard_day.year, @standard_day.month, @standard_day.day)+3600*23.5).to_i, 60*30).to_a    
                @time_arry.map! {|a| Time.at(a)}
            else 
                @key_time = Time.local(@standard_day.year, @standard_day.month, @standard_day.day) + 3600*6 + 3600*24*(i-1)
                @time_next_arry = @key_time.to_i.step( (Time.local(@standard_day.year, @standard_day.month, @standard_day.day)+3600*24*(i-1)+3600*23.5).to_i, 60*30).to_a
                @time_next_arry.map! {|a| Time.at(a)}
                @time_arry.push(@time_next_arry)
            end
        end
        @time_arry.flatten! #この時点では要素はTimeクラス
        @date_arry = @time_arry.map {|a| a.to_date} #これで要素はDateクラス
        @date_arry.uniq!
        
        if Menu.find_by(id: params[:menu_id], status: true).present? #フロントで引数を変更されたり、美容師の方でメニューを削除したばかりでuser側で更新をしてない時のため
            @menu = Menu.find(params[:menu_id])
        else
            flash[:notice_red] = "エラーが発生しました。最初からやりなおしてください。"
            redirect_to root_path
        end
        
        @thead_for_user = true #部分テンプレートの_theadでlinkを無効にするのに使う
    end

    def set_month_calendar_reservation #月間カレンダーで予約
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find(params[:menu_id])
        if params[:win_height].present?
            gon.win_height = params[:win_height].to_i
        end
        if params[:start_date].present?
            @start_year = params[:start_date].to_time.year
            @start_month = params[:start_date].to_time.month
        else
            @start_year = Date.today.year
            @start_month = Date.today.month
        end
    end

    def edit #予約を確定するかどうか最終確認画面
        if Reservation.find_by(id: params[:id]).present? && Reservation.find_by(id: params[:id]).menu.status == true #フロントで引数を変更されたり、美容師の方でメニューを削除したばかりでuser側で更新をしてない時のため
            @reservation = Reservation.find(params[:id])
            @menu = Menu.find(@reservation.menu_id)
            @time = @reservation.start_time
            @hairdresser = @reservation.menu.hairdresser
        else
            flash[:notice_red] = "エラーが発生しました。最初からやりなおしてください。"
            redirect_to root_path
        end
    end

    def various_update
        @reservation = Reservation.find_by(id: params[:reservation_id])
        if @reservation.blank? || @reservation.menu.status == false || @reservation.user_id != nil || Reservation.where(start_time: @reservation.start_time..@reservation.start_time + @reservation.menu.time*60 - 1, user_id: @current_user.id).present? #フロントで引数を変更されたり、美容師の方でメニューを削除したばかりでuser側で更新をしてない時のため
            flash[:notice_red] = "エラーが発生しました。予約の時間を確認してください。他の予約と時間がかぶっている可能性があります。"
            respond_to do |format|
                format.js { render ajax_redirect_to(root_path) }
            end
        else
            if params[:card] == "1" #登録していないクレジットカードで支払う
                @card = "pay_success"   #jsでクレジットカード番号入力モーダルを出す
            elsif params[:point] == "1" #ポイントで支払う
                #現在のポイントが500ポイントより多いとき
                if  @current_user.point >= 500
                    @current_user.point -= 500
                    @current_user.save
                    binding.pry
                    
                    various_change #インスタンスメソッド
    
                    respond_to do |format|
                        format.js { render ajax_redirect_to(users_complete_path) }
                    end
                else
                    @error = "point_error" #jsでエラー文を表示させる
                end
            elsif params[:registered_card] == "1" #登録済みのクレジットカードで支払う
                card = UserCard.find_by(user_id: @current_user.id)
                if card
                    Payjp.api_key = ENV['SECRET_KEY']
                    Payjp::Charge.create(
                        :amount => 500,
                        :customer => card.customer_id, #顧客ID
                        :currency => 'jpy' #日本円
                    )

                    #お金を記録
                    @money = Money.new(user_id: @current_user.id)
                    @money.save

                    various_change #インスタンスメソッド

                    respond_to do |format|
                        format.js { render ajax_redirect_to(users_complete_path) } #予約が完了しました画面にいく
                    end
                else
                    @error = "registered_card_error" #jsでエラー文を表示させる
                end
            else 
                @error = "check_error" #jsでエラー文を表示させる
            end
        end
    end

    def pay #登録していないクレジットカードで支払う
        @reservation = Reservation.find_by(id: params[:reservation_id])
        if @reservation.blank? || Reservation.where(start_time: @reservation.start_time..@reservation.start_time + @reservation.menu.time*60 - 1, user_id: @current_user.id).present? #フロントで引数を変更されたり、美容師の方でメニューを削除したばかりでuser側で更新をしてない時のため
            flash[:notice_red] = "エラーが発生しました。予約の時間を確認してください。他の予約と時間がかぶっている可能性があります。"
            redirect_to root_path
        else
            Payjp.api_key = ENV['SECRET_KEY']
            #Charge.createなので顧客情報は保存されない Payjp::Customer.createのとき顧客情報が保存される
            Payjp::Charge.create(
                :amount => 500, #支払金額を入力
                :card => params['payjp-token'],
                :currency => 'jpy', #日本円
            )
            
            #お金を記録 adminで売り上げ金額を見るため
            @money = Money.new(user_id: @current_user.id)
            @money.save

            various_change #インスタンスメソッド

            redirect_to users_complete_path
        end
    end

    def complete  #予約が完了しました のviewを返す
    end

    def cancel
        #予約した時間のreservationsテーブルのレコードのuser_id(カラム)とuser_request(カラム)をupdateする。
        @reservation = Reservation.find_by(menu_id: params[:menu_id], user_id: @current_user.id, start_time: params[:start_time])
        @reservation.user_id = nil
        @reservation.notification_status = 0
        @reservation.save
        
        #予約した時間から施術が終わる時間までの間の時間に、start_time(カラム)が存在するreservationsテーブルのレコードのstatus(カラム)をupdateする。そうすることで予約した時間から施術が終わる時間までの時間は予約を入れることができるようにする
        @time_min = @reservation.start_time
        @time_max = @reservation.start_time + @reservation.menu.time*60 -1
        @reservations = @reservation.menu.hairdresser.reservations.where(start_time: @time_min..@time_max)
        @reservations.update_all(:status => false )

        #支払った金額をポイントで返す
        @current_user.point += 500
        @current_user.save

        #updateで作成したコメントのレコードを削除
        @hairdresser_id = @reservation.menu.hairdresser_id
        @menu_id = @reservation.menu.id
        @start_time = @reservation.start_time
        @hairdresser_comment = HairdresserComment.find_by(user_id: @current_user.id, hairdresser_id: @hairdresser_id, menu_id: @menu_id, start_time: @start_time)
        @hairdresser_comment.destroy
        
        #予約をキャンセルした情報を保存
        @cancel_reservation = CancelReservation.new(menu_id: params[:menu_id], user_id: @current_user.id, hairdresser_id: @hairdresser_id, start_time: params[:start_time])
        @cancel_reservation.reservation_token = @reservation.reservation_token
        @cancel_reservation.save

        #チャットルームとそのメッセージを削除
        @chat = Chat.find_by(reservation_id: @reservation.id)
        @chat.destroy
        @chat_messages = ChatMessage.where(room_id: @chat.room_id)
        @chat_messages.destroy_all

        #美容師にキャンセルが入ったことを知らせる
        @digest = @reservation.menu.hairdresser.activation_digest
        @reservation_token = @reservation.reservation_token
        data = {reservation_token: @reservation_token, digest: @digest}
        RoomChannel.notice_cancel(data)
    
        flash[:notice] = "予約をキャンセルしました"
        redirect_to users_reservations_path
    end

    def various_change #このコントローラ内で使うメソッド インスタンスメソッド
        #予約した時間のreservationsテーブルのレコードのuser_idとuser_requestをupdate
        @reservation = Reservation.find(params[:reservation_id])
        @reservation.user_id = @current_user.id
        if @reservation.update(reservation_params)

            #予約した時間から施術が終わる時間までに存在するreservationsテーブルのレコードのstatusをupdate その時間内は予約を入れられないようにする
            @time_min = @reservation.start_time
            @time_max = @reservation.start_time + @reservation.menu.time*60 -1
            @reservations = @reservation.menu.hairdresser.reservations.where(start_time: @time_min..@time_max)
            @reservations.update_all(:status => true )

            #後で客に評価させるためにコメントのレコードをつくる
            @hairdresser_id = @reservation.menu.hairdresser_id
            @menu_id = @reservation.menu.id
            @start_time = @reservation.start_time
            @hairdresser_comment = HairdresserComment.new(user_id: @current_user.id, hairdresser_id: @hairdresser_id, menu_id: @menu_id, start_time: @start_time)
            @hairdresser_comment.save

            #チャットルーム作成
            @room = Room.new
            @room.save
            @chat = Chat.new(user_id: @current_user.id, hairdresser_id: @hairdresser_id, room_id: @room.id, reservation_id: @reservation.id)
            @chat.save

            #最初のメッセージを作成 美容師への要望が最初のメッセージになる 空白の場合rollbackされる
            @chat_message = ChatMessage.new(user_id: @current_user.id, room_id: @room.id, message: @reservation.user_request)
            @chat_message.save 
            
            #予約完了のメールを送る
            @user = User.find(@reservation.user_id)
            if @user.email.include?("@twitter.com") == false
                NotificationMailer.reservation_complete_mail(@reservation).deliver_now 
            end
            
            #美容師に予約が入ったことを知らせる
            @digest = @reservation.menu.hairdresser.activation_digest
            @token = @reservation.reservation_token
            data = {reservation_token: @token, digest: @digest}
            RoomChannel.notice_reservation(data)
        else
            flash[:notice_red] = "エラーが発生しました。"
            redirect_to root_path
        end
    end

    private
    def reservation_params
		params.permit(:user_request)
    end

end


