class MenusController < ApplicationController

    include AjaxHelper 

    def new
        @menu = Menu.new
    end

    def create
        @menu = Menu.new(menu_params)
        @menu.category = params[:menu][:category1] + params[:menu][:category2] + params[:menu][:category3] + params[:menu][:category4]
        @menu.hairdresser_id = @current_hairdresser.id
        if @menu.save
            flash[:notice] = "メニューを保存しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(menus_path) }
            end
        else
            #バリデーションのメッセージ
            if @menu.errors.added?(:name, :too_short, :count=>2) || @menu.errors.added?(:name, :too_long, :count=>12) 
                @error_name_short = "名前は2文字以上20文字以下で入力してください"
            end
            if @menu.errors.added?(:explanation, :too_short, :count=>10) || @menu.errors.added?(:explanation, :too_short, :count=>160)
                @error_explanation_short = "説明は10文字以上20文字以下で入力してください"
            end
            if @menu.errors.added?(:time, :blank)
                @error_time_blank = "時間を選択してください"
            end
            if @menu.errors.added?(:category, :invalid, :value=>"0000")
                @error_category_invalid = "最低一つチェックしてください"
            end
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
