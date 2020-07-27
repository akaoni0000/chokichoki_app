class Users::ReservationsController < ApplicationController

    include AjaxHelper 

    before_action :force_comment, only: [:reservation_index, :edit]

    def reservation_index
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find(params[:menu_id])
    end

    def show
    end

    def index
        @reservations = Reservation.where(user_id: @current_user.id).order(start_time: :asc)

        #日付(日まで)の数を調べる @day_numberがその数
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

    def edit
        @reservation = Reservation.find(params[:id])
    end
    def update
       
        if params[:card] == "1"
            @card = "pay_success"
        elsif params[:point] == "1"
            #現在のポイントが500ポイントより多いとき
            if  @current_user.point >= 500
                @current_user.point -= 500
                @current_user.save
            
                #予約した時間のreservationsテーブルのレコードのuser_idとuser_requestをupdate
                @reservation = Reservation.find(params[:id])
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
                @error = "point_error"
            end
        elsif params[:registered_card] == "1"
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
                    format.js { render ajax_redirect_to(users_complete_path) }
                end
            else
                @error = "registered_card_error"
            end
        else 
            @error = "check_error"
        end
    end

    def pay
        Payjp.api_key = ENV['SECRET_KEY']
        #Charge.createなので顧客情報は保存されない Payjp::Customer.createのとき顧客情報が保存される
        Payjp::Charge.create(
            :amount => 500, #支払金額を入力
            :card => params['payjp-token'],
            :currency => 'jpy', #日本円
        )
        
        #お金を記録
        @money = Money.new(user_id: @current_user.id)
        @money.save

        #予約した時間のreservationsテーブルのレコードのuser_id(カラム)とuser_request(カラム)をupdateする。
        @reservation = Reservation.find(params[:reservation_id])
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

    def complete
    end

    private
    def reservation_params
		params.permit(:user_request)
    end

end


