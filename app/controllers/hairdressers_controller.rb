class HairdressersController < ApplicationController

    include AjaxHelper 

    def create #まだactivation_statusはfalse メールアドレス認証は済んでいない メールを送る
        @hairdresser = Hairdresser.new(hairdresser_params)
        if @hairdresser.save   
            #美容師のヘアスタイルの写真のレコードを作成 hairdressersテーブルとstyle_imagesテーブルは1対1の関係であり、同じテーブルにした方がいいと思ったが、style_imagesコントローラを作りたかったので独立させた。
            @style = StyleImage.new(hairdresser_id: @hairdresser.id)
            @style.save
            session[:not_activation_hairdresser_id] = @hairdresser.id
            session[:not_activation_hairdresser_token] = @hairdresser.activation_token
            session[:not_activation_hairdresser_deadline] = Time.now + 600
            NotificationMailer.registration_complete_mail(@hairdresser, @hairdresser.activation_token, "hairdresser").deliver_now
        else 
            validation_message #インスタンスメソッド
        end
    end

    def resend #メールの再送信 前のメールを送ってから10分以内に [メールを再送する] をクリックしないと再送されない
        if session[:not_activation_hairdresser_deadline].present? && Time.now <= session[:not_activation_hairdresser_deadline] #メールの再送が行えるのはメールを送ってから10分間の間
            @hairdresser = Hairdresser.find(session[:not_activation_hairdresser_id]) 
            @token = session[:not_activation_hairdresser_token]
            @hairdresser.activation_deadline_at = Time.now + 600 #新しく制限時間を設ける(メールを送信してから10分以内)
            @hairdresser.save
            session[:not_activation_hairdresser_deadline] = Time.now + 600 #再びメールの再送が行えるのはメールを送ってから10分間の間
            NotificationMailer.registration_complete_mail(@hairdresser, @token, "hairdresser").deliver_now 
        else
            flash[:notice_red] = "要求がタイムアウトになりました。最初からやり直してください。"
            respond_to do |format|
                format.js { render ajax_redirect_to(root_path)}
            end
        end
    end

    def activation #登録認証メールのurlをクリックしたらここにくる
        @token = params[:token]
        @hairdresser = Hairdresser.find_by(email: params[:email])
        @digest = @hairdresser.activation_digest
        @deadline_at = @hairdresser.activation_deadline_at
        @true_or_false = BCrypt::Password.new(@digest).is_password?(@token) #トークンをハッシュ化したものはdigestか確かめる
        if Time.now <= @deadline_at && @true_or_false #メールが送られてから10分以内 かつ トークンをハッシュ化したものはdigest
            @hairdresser.activation_status = true #メール認証成功
            @hairdresser.save
            flash[:notice] = "メールアドレスの認証が完了しました"   
            redirect_to hairdresser_wait_path(@hairdresser.id)
        else
            redirect_to deadline_path
        end
    end

    def wait #adminに承認されていないhairdresserはログインするとここにくる
        @hairdresser = Hairdresser.find(params[:id])
        if @hairdresser.reject_status != nil #adminにrejectされたら発動
           @i = @hairdresser.reject_status.count("1")
           @hairdresser.destroy
           session[:reject_id] = @hairdresser.id
        end
    end

    def guide #非同期でjsを呼ぶ
        @reservation_number = @current_hairdresser.reservations.length
    end

    def edit #アカウント設定
        @hairdresser = Hairdresser.find(@current_hairdresser.id)
        if params[:profile].present?
            @profile = true
        end
        if params[:shop_info].present?
            @shop_info = true
            @shop_name = @hairdresser.shop_name
        end
        if params[:password].present?
            @password = true
        end
        if params[:current_password].present? && @hairdresser.authenticate(params[:current_password])
            @current_password = true
        elsif params[:current_password].present? && @hairdresser.authenticate(params[:current_password]) == false || params[:current_password] == ""
            @current_password = false
        end
    end

    def update #アカウント設定のプロフィールをupdate
        @hairdresser = Hairdresser.find(@current_hairdresser.id)
        if params[:hairdresser][:shop_latitude].present? && @hairdresser.update(hairdresser_params)
            flash[:notice] = "プロフィール情報を更新しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(edit_hairdresser_path(@current_hairdresser.id))}
            end
        else
            validation_message
        end
    end

    def password_update #アカウント設定のパスワードをupdate
        @hairdresser = Hairdresser.find(@current_hairdresser.id)
        if params[:hairdresser][:password] == params[:hairdresser][:password_confirmation] && 6 <= params[:hairdresser][:password].length && params[:hairdresser][:password].length <= 20 #update時のvalidationを設定したかったが、設定するとパスワードをupdateせず他のカラムをupdateするときも発動するのでここで記述する
            @hairdresser.update(hairdresser_params)
            flash[:notice] = "パスワードを更新しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(edit_hairdresser_path(@current_hairdresser.id)) }
            end
        else
            if params[:hairdresser][:password].length <= 5 || params[:hairdresser][:password].length >= 21
                @short_long_error = "パスワードは6文字以上20文字以下で入力してください"
            end
            if params[:hairdresser][:password] != params[:hairdresser][:password_confirmation]
                @match_error = "パスワードが一致しません"
            end
        end
    end

    def index
        @hairdressers = Hairdresser.where(judge_status: true) #承認された美容師だけ
    end

    def login
        @hairdresser = Hairdresser.find_by(email: params[:email])
        if @hairdresser.present?
            if @hairdresser.authenticate(params[:password]) && @hairdresser.judge_status == true
                session[:hairdresser_id] = @hairdresser.id
                flash[:notice] = "ログインしました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdressers_reservations_path) }
                end
            elsif @hairdresser.authenticate(params[:password]) && @hairdresser.judge_status == false   #承認されていない
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_wait_path(@hairdresser.id)) }
                end
            else
            end
        else
        end
    end

    def logout
        session[:hairdresser_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to hairdresser_top_path
    end
    
    #ここから下3つはログインしていない時、パスワードを忘れた時の処理
    def password_reset #パスワードを忘れた時、パスワード再設定から送られてくる
        @email = params[:email]
        @hairdresser = Hairdresser.find_by(email: @email, activation_status: true, judge_status: true)
        if @hairdresser.present? && @email.include?("twitter") == false #twitterアカウントではない twitterアカウントのパスワード変更はない
            token = SecureRandom.urlsafe_base64
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            digest = BCrypt::Password.create(token, cost: cost)
            @hairdresser.password_reset_digest = digest
            @hairdresser.password_reset_deadline_at = Time.now + 600
            @hairdresser.save
            NotificationMailer.password_reset_mail(@hairdresser, token, "hairdresser").deliver_now
            @success = true
        else
            @error = true #入力されたメールアドレスはデータベースに存在しない
        end
    end

    def password_update_as_forget #get パスワードを忘れたときのメールのURLをクリックしたとき新しいパスワードを入力する画面を返す
        @token = params[:token]
        @hairdresser = Hairdresser.find_by(email: params[:email])
        @digest = @hairdresser.password_reset_digest
        @deadline_at = @hairdresser.password_reset_deadline_at
        @true_or_false = BCrypt::Password.new(@digest).is_password?(@token)
        if Time.now <= @deadline_at && @true_or_false #メールが送信されてから10分以内 かつ トークンをハッシュ化したのがdigest
            session[:password_reset_hairdresser_id] = @hairdresser.id
            session[:password_reset_deadline] = Time.now + 600 #このviewを返したから10分以内に新しいパスワードを入力しないとダメ
        else
            redirect_to deadline_path
        end
    end

    def password_update_when_not_login #patch パスワード再設定のviewを表示させてから10分以内に新しいパスワードを入力しなくてはいけない
        if session[:password_reset_deadline].present? && Time.now <= session[:password_reset_deadline]
            if params[:hairdresser][:password] == params[:hairdresser][:password_confirmation] && 6 <= params[:hairdresser][:password].length && params[:hairdresser][:password].length <= 20 #update時のvalidationを設定したかったが、設定するとパスワードをupdateせず他のカラムをupdateするときも発動するのでここで記述する
                @hairdresser = Hairdresser.find(session[:password_reset_hairdresser_id])
                @hairdresser.update(hairdresser_params)
                flash[:notice] = "パスワードを更新しました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(hairdresser_top_path) }
                end
            else
                if params[:hairdresser][:password].length <= 5 || params[:hairdresser][:password].length >= 21
                    @short_long_error = "パスワードは6文字以上20文字以下で入力してください"
                end
                if params[:hairdresser][:password] != params[:hairdresser][:password_confirmation]
                    @match_error = "パスワードが一致しません"
                end
            end
        else
            flash[:notice_red] = "要求がタイムアウトになりました。最初からやり直してください。"
            redirect_to root_path
        end
    end

    def validation_message #インスタンスメソッド どのエラーに引っ掛かったのか特定して、jsで引っ掛かったフォームの枠を赤くしてその上にバリデーションメッセージをおく
        #バリデーションのメッセージ
        @total_error = @hairdresser.errors.messages.length
        if @hairdresser.errors.added?(:name, :too_short, :count=>2) || @hairdresser.errors.added?(:name, :too_long, :count=>10)
            @error_name_short_long = "名前は2文字以上10文字以下で入力してください"
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
        if @hairdresser.errors.added?(:shop_latitude, :blank) || @hairdresser.errors.added?(:shop_longitude, :blank) || params[:hairdresser][:shop_latitude].blank?
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
    

    private
	def hairdresser_params
		params.require(:hairdresser).permit(:name, :email, :shop_name, :post_number, :address, :password, :password_confirmation, :introduction, :hairdresser_image, :confirm_image, :sex, :shop_latitude, :shop_longitude)
	end
end
