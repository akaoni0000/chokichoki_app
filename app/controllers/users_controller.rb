class UsersController < ApplicationController

    before_action :force_comment, only: [:show]

    include AjaxHelper 

    def create 
        @user = User.new(user_params)
        @user.save
        session[:user_id] = @user.id
        redirect_to user_path(@user.id)
    end

    def login
        if @user = User.find_by(email: params[:email])
            if @user.authenticate(params[:password]) #authenticateは、引数に渡された文字列 (パスワード) をハッシュ化した値と、データベース内にあるpassword_digestカラムの値を比較します。
                session[:user_id] = @user.id
                flash[:notice] = "ログインしました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(user_path(@user.id)) }
                end
            else
            end
        else
        end
    end
      
    def logout
        session[:user_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to root_path
    end

    def show
        @user = User.find(params[:id])
        @hairdressers = Hairdresser.all
        @hairdresser_model = Hairdresser
        @reservations = Reservation.where(user_id: @user.id) 
    end


    private
	def user_params
		params.require(:user).permit(:name, :email, :password, :phone_number, :sex)
	end

end
