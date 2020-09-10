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
                format.js { render ajax_redirect_to(preparation_path) }
            end
        else
            validation
        end
    end

    def edit
        @menu = Menu.find_by(id: params[:id], hairdresser_id: @current_hairdresser.id, status: false)
        if @menu.blank?
            redirect_to menus_path
        end
    end

    def update
        @menu = Menu.find_by(id: params[:id], hairdresser_id: @current_hairdresser.id)
        @menu.category = params[:menu][:category1] + params[:menu][:category2] + params[:menu][:category3] + params[:menu][:category4]
        if @menu.update(menu_params)
            flash[:notice] = "メニューを編集しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(preparation_path) }
            end
        else
            validation
        end
    end

    def index
        @menus = Menu.where(hairdresser_id: @current_hairdresser.id, status: true)
    end

    def status_down
        @menu = Menu.find_by(id: params[:menu_id], hairdresser_id: @current_hairdresser.id, status: true)
        if @menu.reservations.blank? || @menu.reservations.map {|reservation| Time.now < reservation.start_time && reservation.user_id != nil}.include?(true) == false
            @menu.status = false
            @menu.menu_update_status = true
            @menu.save
            flash[:notice] = "掲載を中止しました"
        else
            flash[:notice_red] = "そのメニューには予約が入っているため掲載中止にはできません"
        end
        redirect_to menus_path
    end

    def preparation
        @menus = Menu.where(hairdresser_id: @current_hairdresser.id, status: false)
    end

    def status_update
        @menu = Menu.find_by(id: params[:menu_id], hairdresser_id: @current_hairdresser.id, status: false)
        if @menu.present?
            @menu.status = true
            @menu.menu_update_status = true
            @menu.save
            flash[:notice] = "掲載しました"
        else
            flash[:notice_red] = "エラーが発生しました"
        end
        redirect_to preparation_path
    end
    
    def choice
        @menus = Menu.where(hairdresser_id: params[:hairdresser_id], status: true)
    end
    
    def validation #インスタンスメソッド
        #バリデーションのメッセージ
        if @menu.errors.added?(:name, :too_short, :count=>2) || @menu.errors.added?(:name, :too_long, :count=>12) 
            @error_name_short = "名前は2文字以上12文字以下で入力してください"
        end
        if @menu.errors.messages[:name_only].present?
            @error_name_taken = "その名前のメニューは既に存在します"
        end
        if @menu.errors.added?(:explanation, :too_short, :count=>10) || @menu.errors.added?(:explanation, :too_short, :count=>160)
            @error_explanation_short = "説明は10文字以上160文字以下で入力してください"
        end
        if @menu.errors.added?(:time, :blank)
            @error_time_blank = "時間を選択してください"
        end
        if @menu.errors.added?(:category, :invalid, :value=>"0000")
            @error_category_invalid = "最低一つチェックしてください"
        end
    end

    private
	def menu_params
		params.require(:menu).permit(:name, :explanation, :time, :menu_image)
    end
    
end
