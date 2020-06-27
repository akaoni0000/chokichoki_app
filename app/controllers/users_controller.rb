class UsersController < ApplicationController

    before_action :force_comment, only: [:show]

    include AjaxHelper 

    def new
        @user = User.new
    end

    def create 
        if  params[:password] == params[:password_confirmation]
            @user = User.new(user_params)
            @user.save
            session[:user_id] = @user.id
            redirect_to user_path(@user.id)
        else
            @error_message = "パスワードが一致しません"
            render "users/new"
        end
    end

    def login
        if @user = User.find_by(email: params[:email])
            if @user.authenticate(params[:password]) #このメソッドは、引数に渡された文字列 (パスワード) をハッシュ化した値と、データベース内にあるpassword_digestカラムの値を比較します。
                session[:user_id] = @user.id
                flash[:notice] = "ログインしました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(user_path(@user.id)) }
                end
            else
                @authenticate_error = "password_fail"
            end
        else
            @authenticate_error = "email_fail"
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
		params.permit(:name, :email, :password, :password_confirmation, :phone_number, :sex)
	end

end
