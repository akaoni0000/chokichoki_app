class Hairdressers::ReservationsController < ApplicationController

    def reservation_index  #indexにidは渡さない方がいいのでオリジナルを作った
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu_id = params[:menu_id]
        @menu = Menu.find(params[:menu_id])
        @year = Time.now.year
        @month = Time.now.month
        @day = Time.now.day
        if 0 <= Time.now.min && Time.now.min <= 29
            @min = 30
            @hour = Time.now.hour
        elsif 30 <= Time.now.min && Time.now.min <= 59
            @min = 0
            @hour = Time.now.hour + 1
        end
    end

    def ajax_time_form
        @year = params[:date_year].to_i
        @month = params[:date_month].to_i
        @day = params[:date_day].to_i
        if 0 <= Time.now.min && Time.now.min <= 29
            @min = 30
            @hour = Time.now.hour
        elsif 30 <= Time.now.min && Time.now.min <= 59
            @min = 0
            @hour = Time.now.hour + 1
        end
    end

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
        @menu_id = params[:menu_id]
        @reservations = Reservation.where(menu_id: @menu_id)
    end
    
    def create
        @reservation = Reservation.new(reservation_params) 
        @reservation.menu_id = params[:menu_id]
        if @reservation.save
           redirect_to new_hairdressers_reservation_path(year: @reservation.start_time.year, month: @reservation.start_time.month, day: @reservation.start_time.day, hour: @reservation.start_time.hour, min: @reservation.start_time.min, menu_id: params[:menu_id] )
        else
            @year = @reservation.start_time.year
            @month = @reservation.start_time.month
            @day = @reservation.start_time.day
            @hour = @reservation.start_time.hour
            @min = @reservation.start_time.min
            @reservations = Reservation.where(menu_id: params[:menu_id])
            @hairdresser = session[:hairdresser_id]
            @menu_id = params[:menu_id]
            render "hairdressers/reservations/new"
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
