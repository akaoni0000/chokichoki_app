class Hairdressers::ReservationsController < ApplicationController

    def index #実際に予約が入っている予約一覧
        @reservations = @current_hairdresser.reservations.where.not(user_id: nil).order(start_time: :asc) #入っている予約を取り出す
        @date_arry = @reservations.all.pluck(:start_time).map {|a| a.to_date}
        @date_arry.uniq!
        @date_number = @date_arry.length

        @notice_reservations = @current_hairdresser.reservations.where.not(notification_status: true)   #まだ通知を受け取っていない予約 この入れ物はupdateするためにつかう
        if @notice_reservations.present?
            flash[:notice_reservations] = @notice_reservations
            @notice_reservations.update_all(:notification_status => true)
        end
    end

    def cancel_index #キャンセルされた予約一覧
        @cancel_reservations = CancelReservation.where(hairdresser_id: @current_hairdresser.id).order(start_time: :asc)
        @date_arry = @cancel_reservations.all.pluck(:start_time).map {|a| a.to_date}
        @date_arry.uniq!
        @date_number = @date_arry.length

        @notice_cancel_reservations = CancelReservation.where(hairdresser_id: @current_hairdresser.id, notification_status: false)
        if @notice_cancel_reservations.present?
            flash.now[:notice_cancel_reservations] = @notice_cancel_reservations
            @notice_cancel_reservations.update_all(:notification_status => true )
        end
    end

    def set_week_calendar_reservation #週間カレンダー
        calendar
        @menu = Menu.find(params[:menu_id])
        @thead_for_hairdresser = true
    end

    def calendar_index
        calendar
        @calendar_for_index = true
    end

    def calendar_show
        @reservations = Reservation.where(start_time: params[:time]).select {|reservation| reservation.menu.hairdresser == @current_hairdresser && reservation.menu.status == true}
        @menus = @reservations.map {|reservation| reservation.menu}
        @time = params[:time]
    end

    def create_destroy_reservation #週間カレンダーからの予約作成 予約の削除も行う
        if params[:start_time].present?
            @reservation_start_time_arry = params[:start_time]
            @reservation_start_time_arry.map! {|a| Reservation.new(start_time: a, menu_id: params[:menu_id], reservation_token: SecureRandom.urlsafe_base64)} #has_secure_tokenが発動しなかった
            Reservation.import @reservation_start_time_arry #これでinsertが一括でできる
        end

        @reservations_user_exist = @current_hairdresser.reservations.where.not(user_id: nil)
        @reservations_user_exist.all.each do |reservation|
            @time_min = reservation.start_time
            @time_max = reservation.start_time + reservation.menu.time*60 -1
            @reservations = @current_hairdresser.reservations.where(start_time: @time_min..@time_max)
            @reservations.update_all(:status => true )
        end

        if params[:start_time_remove].present?
            @reservation_start_time_remove_arry = params[:start_time_remove]
            @reservation_start_time_remove_arry.map! {|a| Reservation.find_by(start_time: a, menu_id: params[:menu_id], user_id: nil)}
            @reservation_id_arry = @reservation_start_time_remove_arry.pluck(:id)
            Reservation.where(id: @reservation_id_arry).destroy_all
        end

        flash[:notice] = "変更を保存しました"
        redirect_to hairdressers_set_week_calendar_reservation_path(menu_id: params[:menu_id], standard_day: params[:standard_day], win_height: params[:win_height])
    end

    def set_month_calendar_reservation
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find_by(id: params[:menu_id], hairdresser_id: @current_hairdresser.id)
        if @menu.blank? #フロントで引数を変えられたとき
            flash[:notice_red] = "その操作は禁じられています"
            redirect_to root_path
        end
        if params[:win_height].present? #リンクの 前の月 次の月 をクリックしたらある
            gon.win_height = params[:win_height].to_i
        end
        if params[:start_date].present? #リンクの 前の月 次の月 をクリックしたらある
            @start_year = params[:start_date].to_time.year
            @start_month = params[:start_date].to_time.month
        else
            @start_year = Date.today.year
            @start_month = Date.today.month
        end
        if params[:win_scroll].present? #リンクの カレンダーに戻る をクリックしたらある
            gon.scroll = true
        end
    end

    def new
        @reservation = Reservation.new

        #フォームの初期値
        @year = params[:year].to_i
        @month = params[:month].to_i
        @day = params[:day].to_i
        @hour = params[:hour].to_i
        @min = params[:min].to_i

        @menu = Menu.find_by(id: params[:menu_id], hairdresser_id: @current_hairdresser.id)
        if @menu.present?
            @min_time = Date.new(@year, @month, @day).to_time
            @max_time = Date.new(@year, @month, @day).to_time.end_of_day
            @reservations = @menu.reservations.where(start_time: @min_time..@max_time).order(start_time: :asc) #start_timeカラムが早い日付の順番にで@reservationsを整理する 本当はwhereでどうにかしたかったが、解決策がなくこのような形になった
        else
            flash[:notice_red] = "その操作は禁じられています"
            redirect_to root_path
        end
    end

    def create #月間カレンダーからの予約作成
        @reservation = Reservation.new(reservation_params)
        @menu = Menu.find_by(id: params[:menu_id], hairdresser_id: @current_hairdresser.id)
        if @menu.blank? #フロントで引数を変えられたとき
            flash[:notice_red] = "その操作は禁じられています" #フロントで引数を変更
            redirect_to root_path
        end
        @reservation.menu_id = @menu.id
        @year = @reservation.start_time.year
        @month = @reservation.start_time.month
        @day = @reservation.start_time.day
        @hour = @reservation.start_time.hour
        @min = @reservation.start_time.min
        if @reservation.save
            #newのフォームの初期値を設定
            if @hour == 23 && @min == 30
            else
                @min += 30    #時間を登録したらフォームにはその時間の30分後の時間が初期値として入力されているようにする
            end
            flash[:notice] = "予約を追加しました"
            redirect_to new_hairdressers_reservation_path(menu_id: @reservation.menu_id, year: @year, month: @month, day: @day, hour: @hour, min: @min)
        else
            @min_time = Date.new(@year, @month, @day).to_time
            @max_time = Date.new(@year, @month, @day).to_time.end_of_day
            @reservations = @menu.reservations.where(start_time: @min_time..@max_time).order(start_time: :asc)
            if @reservation.errors.messages[:time_validation_30].present?
                @error = "予約は今日の日時から90日以内の時刻しか予約できません"
            else
                @error = "その時間はすでに登録されています"
            end
            render "hairdressers/reservations/new"
        end
    end

    def destroy
        @reservation = Reservation.find(params[:id])
        if @reservation.menu.hairdresser == @current_hairdresser && @reservation.user_id == nil
            @reservation.destroy
            flash[:notice_red] = "予約を削除しました"
            redirect_to new_hairdressers_reservation_path(year: @reservation.start_time.year, month: @reservation.start_time.month, day: @reservation.start_time.day, hour: @reservation.start_time.hour, min: @reservation.start_time.min, menu_id: @reservation.menu_id )
        else
            flash[:notice_red] = "その操作は禁じられています" #フロントで引数を変更
            redirect_to root_path
        end
    end

    def calendar #インスタンスメソッド
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

        @clock_arry = ["06:00", "06:30", "07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "14:00", "14:30", "15:00","15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00", "21:30", "22:00", "22:30", "23:00", "23:30"]

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
    end

    private
    def reservation_params
        params.permit(:start_time)
    end
end
