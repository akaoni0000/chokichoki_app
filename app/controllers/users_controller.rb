class UsersController < ApplicationController

    before_action :force_comment, only: [:show]

    include AjaxHelper 

    def create 
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            respond_to do |format|
                format.js { render ajax_redirect_to(user_path(@user.id)) }
            end
        else
            #バリデーションのメッセージ
            @total_error = @user.errors.messages.length
            if @user.errors.added?(:name, :too_short, :count=>2) || @user.errors.added?(:name, :too_long, :count=>20)
                @error_name_short = "名前は2文字以上20文字以下で入力してください"
            end
            if @user.errors.added?(:name, :taken, :value=>params[:user][:name])
                @error_name_taken = "その名前は既に登録されています"
            end
            if @user.errors.added?(:email, :invalid, :value=>params[:user][:email])
                @error_email_invalid = "正しいメールアドレスを入力してください"
            end
            if @user.errors.added?(:email, :taken, :value=>params[:user][:email])
                @error_email_taken = "そのメールアドレスは既に登録されています"
            end
            if @user.errors.added?(:phone_number, :invalid, :value=>params[:user][:phone_number])
                @error_phone_invalid = "電話番号は10桁または11桁の半角数字で入力してください"
            end
            if @user.errors.added?(:password, :too_short, :count=>6) || @user.errors.added?(:password, :too_long, :count=>20)
                @error_password_short = "パスワードは6文字以上20文字以下で入力してください"
            end
            if @user.errors.added?(:password_confirmation, :confirmation, :attribute=>"パスワード")
                @error_password_confirmaiton = "パスワードが一致しません"
            end
            if @user.errors.added?(:sex, :blank)
                @error_sex_blank = "性別を選択してください"
            end
        end
    end

    def login
        if @user = User.find_by(email: params[:email])  #メールアドレス　パスワードの順で調べていく
            if @user.authenticate(params[:password]) #authenticateは、引数に渡された文字列 (パスワード) をハッシュ化した値と、データベース内にあるpassword_digestカラムの値を比較します。
                session[:user_id] = @user.id
                flash[:notice] = "ログインしました"
                if params[:reservation_id] == nil
                    respond_to do |format|
                        format.js { render ajax_redirect_to(user_path(@user.id)) }
                    end
                else
                    @reservation_id = params[:reservation_id].to_i
                    respond_to do |format|
                        format.js { render ajax_redirect_to(edit_users_reservation_path(@reservation_id)) }
                    end
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
        @user = User.find(@current_user.id)
        @hairdressers = Hairdresser.all
        @hairdresser_model = Hairdresser
        @reservations = Reservation.where(user_id: @user.id) 
    end


    private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone_number, :sex)
	end

end
