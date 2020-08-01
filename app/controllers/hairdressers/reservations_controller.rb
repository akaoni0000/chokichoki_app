class Hairdressers::ReservationsController < ApplicationController
    
    def index #実際に予約が入っている予約一覧
        @reservations = @current_hairdresser.reservations.where.not(user_id: nil).order(start_time: :asc) #入っている予約を取り出す
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

        #@flash_cofirm_reservations =  @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil)  #まだ通知を受け取っていない予約 この入れ物はviewでフラッシュを表示するか確かめるために使う
        @notice_reservations = @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil)   #まだ通知を受け取っていない予約 この入れ物はupdateするためにつかう
        if @notice_reservations.present?
            session[:update] = "please_reservation_notification_update" #application controllerでnotification_statusを1にするのに使う
            flash[:notice] = "new"
            gon.display_none = "remove_display_none" #jsのwindow.onloadに行き、flashメッセージをtableの中に埋め込む
        end
        
        @user_model = User    #viewで　user =  @user_model.find(reservation.user_id)　とやらずにモデルを関連付けてreservation.userとやりたかったが、関連づけるとreservationsのデータを保存するときuserのデータをnilで保存することができないためこのような形となった
        gon.reverse = "reverse"  #jsのwindow.onloadに行き、順番を逆にする
    end

    def cancel_index #キャンセルされた予約一覧
        @cancels = UserCancel.where(hairdresser_id: @current_hairdresser.id).order(start_time: :asc)
        @Menu = Menu
        @User = User

        #日付(日まで)の数を調べる @day_numberがその数
        @n = 0
        @i = 0
        @cancels.each do |cancel|
            if @i == 0
            elsif @cancels[@i - 1].start_time.year != cancel.start_time.year || @cancels[@i - 1].start_time.month != cancel.start_time.month || @cancels[@i - 1].start_time.day != cancel.start_time.day
                @n += 1
            end
            @i += 1
        end
        @day_number = @n + 1
        
        @user_cancel = UserCancel.where(hairdresser_id: @current_hairdresser.id, notification_status: 0)
        if @user_cancel.present?
            session[:cancel_update] = "please_reservation_notification_cancel_update" #application controllerで使う
            flash[:notice] = "new"
            gon.display_none = "remove_display_none"  #jsのwindow.onloadに行き、flashメッセージをtableの中に埋め込む
        end

        gon.reverse = "reverse" #jsのwindow.onloadに行き、順番を逆にする
    end

    def set_week_calendar_reservation #週間カレンダー
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
        
        #例　配列[1/1 06:00, 1/1 06:30, 1/1 07:00, ..... 1/1 23:30, 1/2 06:00, .....] を作成
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

    def create_destroy_reservation #週間カレンダーからの予約作成
        if params[:start_time].present?
            @reservation_start_time_arry = params[:start_time]
            @reservation_start_time_arry.each do |start_time|
                @reservation = Reservation.new
                @reservation.menu_id = params[:menu_id]
                @reservation.start_time = start_time
                @reservation.save
            end
        end
        
        if params[:start_time_remove].present?
            @reservation_start_time_remove_arry = params[:start_time_remove]
            @reservation_start_time_remove_arry.each do |start_time_remove|
                @reservation = Reservation.find_by(start_time: start_time_remove, menu_id: params[:menu_id])
                @reservation.destroy
            end
        end

        redirect_to hairdressers_set_week_calendar_reservation_path(menu_id: params[:menu_id], standard_day: params[:standard_day])
    end
    
    def set_month_calendar_reservation
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find(params[:menu_id])
    end

    def new
        @reservation = Reservation.new
        @year = params[:year].to_i
        @month = params[:month].to_i
        @day = params[:day].to_i
        @hour = params[:hour].to_i
        @min = params[:min].to_i
        @menu = Menu.find(params[:menu_id])
        @user_model = User
        @reservations = Reservation.where(menu_id: @menu.id)
        @reservations = @reservations.all.order(start_time: :asc) #start_timeカラムが早い日付の順番にで@reservationsを整理する 本当はwhereでどうにかしたかったが、解決策がなくこのような形になった
        @reservations_arry = []
        @reservations.each do |reservation| 
            if reservation.start_time.year == @year && reservation.start_time.month == @month && reservation.start_time.day == @day
                @reservations_arry.push(reservation)
            end
        end
    end

    def create #月間カレンダーからの予約作成
        @reservation = Reservation.new(reservation_params) 
        @validation = Reservation.find_by(menu_id: params[:menu_id], start_time: @reservation.start_time)
        if @validation.present?
            @error = "その時間はすでに設定されています"
            @year = @reservation.start_time.year
            @month = @reservation.start_time.month
            @day = @reservation.start_time.day
            @hour = @reservation.start_time.hour
            @min = @reservation.start_time.min
           
            @menu = Menu.find(params[:menu_id])
            @reservations = Reservation.where(menu_id: @menu.id)
            @reservations_arry = []
            @reservations.each do |reservation| 
                if reservation.start_time.year == @year && reservation.start_time.month == @month && reservation.start_time.day == @day
                    @reservations_arry.push(reservation)
                end
            end
            render "hairdressers/reservations/new"
        else
            @reservation.menu_id = params[:menu_id]
            @reservation.save

            #newのフォームの初期値を設定
            @year = @reservation.start_time.year
            @month = @reservation.start_time.month
            @day = @reservation.start_time.day
            @hour = @reservation.start_time.hour
            @min = @reservation.start_time.min
            if @hour == 23 && @min == 30
            else
                @min += 30    #時間を登録したらフォームにはその時間の30分後の時間が初期値として入力されているようにする
            end
            
            redirect_to new_hairdressers_reservation_path(menu_id: @reservation.menu_id, year: @year, month: @month, day: @day, hour: @hour, min: @min)
        end
    end

    def destroy
        @reservation = Reservation.find(params[:id])
        @reservation.destroy
        redirect_to new_hairdressers_reservation_path(year: @reservation.start_time.year, month: @reservation.start_time.month, day: @reservation.start_time.day, hour: @reservation.start_time.hour, min: @reservation.start_time.min, menu_id: @reservation.menu_id )
    end

    private
    def reservation_params
        params.permit(:start_time)
    end
end
