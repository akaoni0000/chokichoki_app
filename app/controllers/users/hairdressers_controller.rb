class Users::HairdressersController < ApplicationController
    def show
        @hairdresser = Hairdresser.find(params[:id])
        @hairdresser_comments = HairdresserComment.where(hairdresser_id: params[:id])
        @menus = Menu.where(hairdresser_id: @hairdresser.id)
        @menu_model = Menu
        @user_model = User
    end
end
