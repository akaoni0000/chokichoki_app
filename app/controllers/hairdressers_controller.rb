class HairdressersController < ApplicationController

    include AjaxHelper 

    def new
        @hairdresser = Hairdresser.new
    end

    def create 
        if params[:hairdresser][:password] == params[:hairdresser][:password_confirmation]
            @hairdresser = Hairdresser.new(hairdresser_params)
            @hairdresser.save
            redirect_to hairdresser_wait_path
        else
            @hairdresser = Hairdresser.new
            @error_message = "パスワードが一致しません"
            render "hairdressers/new"
        end
    end

    def wait
    end

    def login
        if @hairdresser = Hairdresser.find_by(email: params[:email])
            if @hairdresser.authenticate(params[:password]) && @hairdresser.status == 1
                session[:hairdresser_id] = @hairdresser.id
                flash[:notice] = "ログインしました"
                @style_image = StyleImage.find_by(hairdresser_id: @hairdresser.id)
                if @style_image.present?
                else
                    @style = StyleImage.new(hairdresser_id: @hairdresser.id)
                    @style.save
                end
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_path(@hairdresser.id)) }
                end
            elsif @hairdresser.authenticate(params[:password]) && @hairdresser.status == 0
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_wait_path) }
                end
            else
                @error_authenticate = "password_fail"
            end
        else
            @error_authenticate = "email_fail"
        end
    end

    def logout
        session[:hairdresserr_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to root_path
    end
      

    def show
        @hairdresser = Hairdresser.find(params[:id])
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
		params.require(:hairdresser).permit(:name, :email, :post_number, :address, :introduction, :confirm_image, :password, :password_confirmation)
	end
end
