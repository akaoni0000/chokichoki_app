class Hairdressers::ReservationsController < ApplicationController

    def reservation_index  #indexにidは渡さない方がいいのでオリジナルを作った
        @reservations = Reservation.where(menu_id: params[:menu_id])
        @menu_id = params[:menu_id]
    end

    def index 
        @reservations = Reservation.all
        @user_model = User
    end

    def new
        @reservation = Reservation.new
        @year = params[:year]
        @month = params[:month]
        @day = params[:day]
        @hour = params[:hour]
        @min = params[:min]
        @hairdresser = session[:hairdresser_id]
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
