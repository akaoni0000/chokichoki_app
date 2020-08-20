class HairdressersController < ApplicationController

    include AjaxHelper 

    def create 
        @hairdresser = Hairdresser.new(hairdresser_params)
        if @hairdresser.save   
            #美容師のヘアスタイルの写真のレコードを作成 hairdressersテーブルとstyle_imagesテーブルは1対1の関係であり、同じテーブルにした方がいいと思ったが、style_imagesコントローラを作りたかったので独立させた。
            @style = StyleImage.new(hairdresser_id: @hairdresser.id)
            @style.save
            respond_to do |format|
                format.js { render ajax_redirect_to(hairdresser_wait_path(@hairdresser.id)) }
            end
        else 
            #バリデーションのメッセージ
            @total_error = @hairdresser.errors.messages.length
            if @hairdresser.errors.added?(:name, :too_short, :count=>2)
                @error_name_short = "名前は2文字以上20文字以下で入力してください"
            end
            if @hairdresser.errors.added?(:name, :taken, :value=>params[:hairdresser][:name])
                @error_name_taken = "その名前は既に登録されています"
            end
            if @hairdresser.errors.added?(:email, :invalid, :value=>params[:hairdresser][:email])
                @error_email_invalid = "正しいメールアドレスを入力してください"
            end
            if @hairdresser.errors.added?(:email, :taken, :value=>params[:hairdresser][:email])
                @error_email_taken = "そのメールアドレスは既に登録されています"
            end
            if @hairdresser.errors.added?(:shop_name, :too_short, :count=>2) || @hairdresser.errors.added?(:shop_name, :too_long, :count=>20)
                @error_shop_short = "店舗名は2文字以上20文字以下で入力してください"
            end

            if params[:hairdresser][:post_number] == ""
                @post_number = nil
            else
                @post_number = params[:hairdresser][:post_number].to_i
            end

            if @hairdresser.errors.added?(:post_number, :invalid, :value=>@post_number)
                @error_post_invalid = "ハイフンなし半角7桁の数字を入力してください"
            end
            if params[:hairdresser][:shop_latitude].blank?
                @error_address = "正しい住所を入力してください"
                @total_error += 1
            end
            if @hairdresser.errors.added?(:password, :too_short, :count=>6) || @hairdresser.errors.added?(:password, :too_long, :count=>20)
                @error_password_short = "パスワードは6文字以上20文字以下で入力してください"
            end
            if @hairdresser.errors.added?(:password_confirmation, :confirmation, :attribute=>"Password")
                @error_password_confirmaiton = "パスワードが一致しません"
            end
            if @hairdresser.errors.added?(:confirm_image, :blank)
                @error_confirm_blank = "画像を選択してください"
            end
            if @hairdresser.errors.added?(:sex, :blank)
                @error_sex_blank = "性別を選択してください"
            end
        end
    end

    def wait
        @hairdresser = Hairdresser.find(params[:id])
        if @hairdresser.reject_status != nil
           @i = @hairdresser.reject_status.count("1")
           @hairdresser.destroy
           session[:reject_id] = @hairdresser.id
        end
    end

    def index
        @hairdressers = Hairdresser.where(status: 1) #承認された美容師だけ
        @hairdresser_comment_model = HairdresserComment
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
        redirect_to hairdresser_top_path
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
        redirect_to hairdresser_top_path
    end

    private
	def hairdresser_params
		params.require(:hairdresser).permit(:name, :email, :shop_name, :post_number, :address, :password, :password_confirmation, :introduction, :hairdresser_image, :confirm_image, :sex, :shop_latitude, :shop_longitude)
	end
end
