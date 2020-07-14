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
        @reservations = Reservation.all
        @user_model = User
        @comment_model = HairdresserComment
    end

    def new
        @reservation = Reservation.new
        @year = params[:year]
        @month = params[:month]
        @day = params[:day]
        @hour = params[:hour]
        @min = params[:min]
        @menu = Menu.find(params[:menu_id])
        @reservations = Reservation.where(menu_id: @menu.id)
    end
    
    def create
        @reservation = Reservation.new(reservation_params) 
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
