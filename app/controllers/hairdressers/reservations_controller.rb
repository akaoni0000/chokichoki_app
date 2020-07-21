class Hairdressers::ReservationsController < ApplicationController
    
    def reservation_index  #indexにidは渡さない方がいいのでオリジナルを作った
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu = Menu.find(params[:menu_id])
    end

    # def ajax_time_form
    #     @menu = Menu.find(params[:menu_id])
    #     @year = params[:date_year].to_i
    #     @month = params[:date_month].to_i
    #     @day = params[:date_day].to_i
    #     if 0 <= Time.now.min && Time.now.min <= 29
    #         @min = 30
    #         @hour = Time.now.hour
    #     elsif 30 <= Time.now.min && Time.now.min <= 59
    #         @min = 0
    #         @hour = Time.now.hour + 1
    #     end
    # end

    def index 
        @reservations = @current_hairdresser.reservations.where.not(user_id: nil).order(start_time: :asc)
        #@reservations.update_all(:notification_status => 1 )
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

        @notice_reservations = @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil)   #まだ通知を受け取っていない予約
        
        if @notice_reservations.present?
            @notice_reservations.update_all(:notification_status => 1 )
            flash[:notice] = "new"
            gon.display_none = "remove_display_none"
        end
        @user_model = User    #viewで　user =  @user_model.find(reservation.user_id)　とやらずにモデルを関連付けてreservation.userとやりたかったが、関連づけるとreservationsのデータを保存するときuserのデータをnilで保存することができないためこのような形となった
        @comment_model = HairdresserComment
        gon.reverse = "reverse"

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
    
    def create
        @reservation = Reservation.new(reservation_params) 
        @validation = Reservation.find_by(menu_id: @reservation.menu_id, start_time: @reservation.start_time)
        if @validation
            @error = "その時間はすでに設定されています"
            @year = @reservation.start_time.year
            @month = @reservation.start_time.month
            @day = @reservation.start_time.day
            @hour = @reservation.start_time.hour
            @min = @reservation.start_time.min
            @menu = Menu.find(@reservation.menu_id)
            @reservations = Reservation.where(menu_id: @menu.id)
            @reservations_arry = []
            @reservations.each do |reservation| 
                if reservation.start_time.year == @year && reservation.start_time.month == @month && reservation.start_time.day == @day
                    @reservations_arry.push(reservation)
                end
            end
            render "hairdressers/reservations/new"
        else
            @reservation.save
        
            
            @year = @reservation.start_time.year
            @month = @reservation.start_time.month
            @day = @reservation.start_time.day
            @hour = @reservation.start_time.hour
            @min = @reservation.start_time.min
            if @hour == 23 && @min == 30
            else
                @min += 30
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
        params.permit(:start_time, :menu_id)
    end
    
end
