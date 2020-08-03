class Users::ReservationsController < ApplicationController

    include AjaxHelper #非同期からredirect_toするための記述
    before_action :force_comment, only: [:reservation_index, :edit]

    def index #userの予約一覧
        @reservations = Reservation.where(user_id: @current_user.id).order(start_time: :asc)

        #日付(日)の数を調べる @day_numberがその数  例 1/1 06:00, 1/1 07:00, 1/2 06:00 だと 2
        @n = 0
        @i = 0
        @reservations.each do |reservation|
            if @i == 0
            elsif @reservations[@i - 1].start_time.year != reservation.start_time.year || @reservations[@i - 1].start_time.month != reservation.start_time.month || @reservations[@i - 1].start_time.day != reservation.start_time.day
                @n += 1
            end
            @i += 1
        end
        @day_number = @n + 1

        gon.reverse = "reverse" #jsのwindow.onloadに行き、順番を逆にする
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
        
        #配列[06:00, 06:30, 07:00, ....]を作っただけ 数字を全て数字を全て記述するのが面倒だったので工夫した
        @time_arry = []  
        for i in 0..35 do 
            @time = Time.local(2000,1,1) + 3600*6    
            @time += 60 * 30 * i  
            if @time.hour.to_s.length == 1
                @time_hour = 0.to_s + @time.hour.to_s
            else
                @time_hour = @time.hour
            end
            if @time.min == 0
                @time_min = "00"
            else
                @time_min = @time.min
            end
            @time_arry.push("#{@time_hour}:#{@time_min}")
        end 
        
        #配列を作成         例　配列[1/1 06:00, 1/1 06:30, 1/1 07:00, ..... 1/1 23:30, 1/2 06:00, .....] を作成
        @day_arry = []
        for i in 1..14 do 
            @key_time = Time.local(@standard_day.year, @standard_day.month, @standard_day.day) + 3600*6 + 3600*24*(i-1)
            for n in 0..35 do
                @time = @key_time
                @time += 60 * 30 * n #+30分
                @day_arry.push(@time)
            end
        end

        @menu = Menu.find(params[:menu_id])
    end

    def set_month_calendar_reservation #月間カレンダーで予約
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find(params[:menu_id])
    end

    def edit #予約を確定するかどうか最終確認画面
        @reservation = Reservation.find(params[:id])
    end

    def various_update
        if params[:card] == "1" #登録していないクレジットカードで支払う
            @card = "pay_success"   #jsでクレジットカード番号入力モーダルを出す
        elsif params[:point] == "1" #ポイントで支払う
            #現在のポイントが500ポイントより多いとき
            if  @current_user.point >= 500
                @current_user.point -= 500
                @current_user.save
            
                #予約した時間のreservationsテーブルのレコードのuser_idとuser_requestをupdate
                @reservation = Reservation.find(params[:reservation_id])
                @reservation.user_id = @current_user.id
                @reservation.update(reservation_params)

                #予約した時間から施術が終わる時間までに存在するreservationsテーブルのレコードのstatusをupdate その時間内は予約を入れられないようにする
                @time_min = @reservation.start_time
                @time_max = @reservation.start_time + @reservation.menu.time*60 -1
                @reservations = Reservation.where(start_time: @time_min..@time_max)
                @reservations.update_all(:status => 1 )

                #後で客に評価させるためにコメントのレコードをつくる
                @hairdresser_id = @reservation.menu.hairdresser_id
                @menu_id = @reservation.menu.id
                @start_time = @reservation.start_time
                @hairdresser_comment = HairdresserComment.new(user_id: @current_user.id, hairdresser_id: @hairdresser_id, menu_id: @menu_id, start_time: @start_time)
                @hairdresser_comment.save
 
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

                #予約した時間のreservationsテーブルのレコードのuser_id(カラム)とuser_request(カラム)をupdateする。
                @reservation = Reservation.find(params[:id])
                @reservation.user_id = @current_user.id
                @reservation.update(reservation_params)

                #予約した時間から施術が終わる時間までの間の時間に、start_time(カラム)が存在するreservationsテーブルのレコードのstatus(カラム)をupdateする。そうすることで予約した時間から施術が終わる時間までの時間は予約を入れられないようにする。
                @time_min = @reservation.start_time
                @time_max = @reservation.start_time + @reservation.menu.time*60 -1
                @reservations = Reservation.where(start_time: @time_min..@time_max)
                @reservations.update_all(:status => 1 )
                
                #後で客に評価させるためにコメントのレコードをつくる
                @hairdresser_id = @reservation.menu.hairdresser_id
                @menu_id = @reservation.menu.id
                @start_time = @reservation.start_time
                @hairdresser_comment = HairdresserComment.new(user_id: @current_user.id, hairdresser_id: @hairdresser_id, menu_id: @menu_id, start_time: @start_time)
                @hairdresser_comment.save

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

    def pay #登録していないクレジットカードで支払う
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

        #予約した時間のreservationsテーブルのレコードのuser_id(カラム)とuser_request(カラム)をupdateする。
        @reservation = Reservation.find(params[:reservation_id])
        @reservation.user_id = @current_user.id
        @reservation.update(reservation_params)

        #予約した時間から施術が終わる時間までの間の時間に、start_time(予約時間)が存在するreservationsテーブルのレコードのstatus(カラム)をupdateする。そうすることで予約した時間から施術が終わる時間までの時間は予約を入れられないようにする。
        @time_min = @reservation.start_time
        @time_max = @reservation.start_time + @reservation.menu.time*60 -1
        @reservations = Reservation.where(start_time: @time_min..@time_max)
        @reservations.update_all(:status => 1 )

         #後で客に評価させるためにコメントのレコードをつくる
         @hairdresser_id = @reservation.menu.hairdresser_id
         @menu_id = @reservation.menu.id
         @start_time = @reservation.start_time
         @hairdresser_comment = HairdresserComment.new(user_id: @current_user.id, hairdresser_id: @hairdresser_id, menu_id: @menu_id, start_time: @start_time)
         @hairdresser_comment.save
        
        redirect_to users_complete_path
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
        @reservations = Reservation.where(start_time: @time_min..@time_max)
        @reservations.update_all(:status => 0 )

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
        @user_cancel = UserCancel.new(menu_id: params[:menu_id], user_id: @current_user.id, hairdresser_id: @hairdresser_id, start_time: params[:start_time])
        @user_cancel.save

        redirect_to users_reservations_path
    end

    def complete  #予約が完了しました のviewを返す
    end

    private
    def reservation_params
		params.permit(:user_request)
    end

end


