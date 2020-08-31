class Users::HairdressersController < ApplicationController
    def show
        @hairdresser = Hairdresser.find(params[:id])
        @status = @hairdresser.judge_status
        @hairdresser_comments = HairdresserComment.where(hairdresser_id: params[:id])
        @menus = @hairdresser.menus
        @menus_category = @menus.map {|a| a.category}
        @menus_category.uniq!
        @cut = @menus_category.map {|a| a.slice(0,1)} #カット
        @color = @menus_category.map {|a| a.slice(1,1)} #カラー
        @perm = @menus_category.map {|a| a.slice(2,1)} #パーマ
        @curly = @menus_category.map {|a| a.slice(3,1)} #縮毛
        @reservations = @hairdresser.reservations.where(status: false).order(start_time: "ASC") #予約
        @style_image = StyleImage.find_by(hairdresser_id: @hairdresser.id) #ヘアカタログ
        if params[:profile].present?
            @profile = true
        end 
        if params[:menu].present?
            @menu = true
        end
        if params[:photo].present?
            @photo = true
        end
        if params[:review].present?
            @review = true
        end
    end
end
