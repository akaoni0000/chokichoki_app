class FavoritesController < ApplicationController
    def create
        Favorite.create(user_id: @current_user.id, hairdresser_id: params[:hairdresser_id])
        @hairdresser = Hairdresser.find(params[:hairdresser_id]) #jsで使う
    end

    def destroy
        Favorite.find_by(user_id: @current_user.id, hairdresser_id: params[:id]).destroy
        @hairdresser = Hairdresser.find(params[:id]) #jsで使う
    end

    def index
        @hairdressers = Favorite.where(user_id: @current_user.id).map {|favorite| favorite.hairdresser}
    end
end
