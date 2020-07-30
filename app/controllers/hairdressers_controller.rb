class HairdressersController < ApplicationController

    include AjaxHelper 

    def create 
        @hairdresser = Hairdresser.new(hairdresser_params)
        @hairdresser.save

        #美容師のヘアスタイルの写真のレコードを作成 hairdressersテーブルとstyle_imagesテーブルは1対1の関係であり、同じテーブルにした方がいいと思ったが、style_imagesコントローラを作りたかったので独立させた。
        @style = StyleImage.new(hairdresser_id: @hairdresser.id)
        @style.save
        redirect_to hairdresser_wait_path(@hairdresser.id)
    end

    def wait
        @hairdresser = Hairdresser.find(params[:id])
        if @hairdresser.reject_status != nil
           @i = @hairdresser.reject_status.count("1")
           session[:reject_id] = @hairdresser.id
        end
    end

    def index
        @hairdressers = Hairdresser.where(status: 1) #承認された美容師だけ
        @hairdresser_comment_model = HairdresserComment
        #gon.fix = "header"
    end

    def login
        @hairdresser = Hairdresser.find_by(email: params[:email])
        if @hairdresser.present?
            if @hairdresser.authenticate(params[:password]) && @hairdresser.status == 1
                session[:hairdresser_id] = @hairdresser.id
                flash[:notice] = "ログインしました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_path(@hairdresser.id)) }
                end
            elsif @hairdresser.authenticate(params[:password]) && @hairdresser.status == 0   #承認されていない
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_wait_path(@hairdresser.id)) }
                end
            else
            end
        else
        end
    end

    def logout
        session[:hairdresserr_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to root_path
    end
      
    def show
        @menu_id = Menu.where(hairdresser_id: @current_hairdresser.id)
        @reservations = Reservation.where(menu_id: @menu_id)
        @user_model = User
        @style_image = StyleImage.find_by(hairdresser_id: @current_hairdresser.id)
    end

    def logout
        session[:hairdresser_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to root_path
    end

    private
	def hairdresser_params
		params.require(:hairdresser).permit(:name, :email, :shop_name, :post_number, :address, :password, :introduction, :hairdresser_image, :confirm_image, :sex)
	end
end
