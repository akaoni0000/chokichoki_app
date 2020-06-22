class Users::ReservationsController < ApplicationController

    def reservation_index
        @reservations = Reservation.where(menu_id: params[:menu_id])
    end

end


