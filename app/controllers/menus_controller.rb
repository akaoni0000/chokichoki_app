class MenusController < ApplicationController

    def new
        @menu = Menu.new
    end

    def create
        @menu = Menu.new(menu_params)
        @menu.category = params[:menu][:category1] + params[:menu][:category2] + params[:menu][:category3] + params[:menu][:category4]
        @menu.hairdresser_id = @current_hairdresser.id
        if @menu.save
            redirect_to menus_path
        end
    end

    def index
        @menus = Menu.where(hairdresser_id: @current_hairdresser.id)
    end
    
    def choice
        @menus = Menu.where(hairdresser_id: params[:hairdresser_id])
    end

    private
	def menu_params
		params.require(:menu).permit(:name, :explanation, :time, :menu_image)
    end
    
end
