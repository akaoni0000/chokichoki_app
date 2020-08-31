class UsersController < ApplicationController

    before_action :force_comment, only: [:show]

    include AjaxHelper 

    def create #activation_statusはfalse メール認証は済んでいない
        @user = User.new(user_params)
        if @user.save #saveに成功したらメールを送る
            NotificationMailer.registration_complete_mail(@user, @user.activation_token, "user").deliver_now 
            session[:not_activation_user_id] = @user.id
            session[:not_activation_user_token] = @user.activation_token
            session[:not_activation_user_deadline] = Time.now + 600
        else
            validation_message #インスタンスメソッド
        end
    end

    def resend #メールの再送信 前のメールを送ってから10分以内に [メールを再送] をクリックしなくてはいけない
        if session[:not_activation_user_deadline].present? && Time.now <= session[:not_activation_user_deadline] #メールの再送が行えるのはメールを送ってから10分間の間
            @user = User.find(session[:not_activation_user_id]) 
            @token = session[:not_activation_user_token]
            @user.activation_deadline_at = Time.now + 600 #新しく制限時間を設ける(メールを送信してから10分以内)
            @user.save
            session[:not_activation_user_deadline] = Time.now + 600 #再びメールの再送が行えるのはメールを送ってから10分間の間
            NotificationMailer.registration_complete_mail(@user, @token, "user").deliver_now 
        else
            flash[:notice_red] = "要求がタイムアウトになりました。最初からやり直してください。"
            respond_to do |format|
                format.js { render ajax_redirect_to(root_path)}
            end
        end
    end

    def activation #登録認証メールのurlをクリックしたらここにくる
        @token = params[:token]
        @user = User.find_by(email: params[:email])
        @digest = @user.activation_digest
        @deadline_at = @user.activation_deadline_at
        @true_or_false = BCrypt::Password.new(@digest).is_password?(@token)
        if Time.now <= @deadline_at && @true_or_false #認証メールを送信してから10分以内 かつ トークンをハッシュ化したものがdigest
            @user.activation_status = true #メールアドレスを認証
            @user.save
            session[:user_id] = @user.id #ログイン状態にする
            flash[:notice] = "登録が完了しました"
            redirect_to root_path    
        else
            redirect_to deadline_path
        end
    end

    def login
        if @user = User.find_by(email: params[:email])  #メールアドレス　パスワードの順で調べていく
            if @user.authenticate(params[:password]) && @user.activation_status == true && @user.email.include?("twitter") == false #authenticateは、引数に渡された文字列 (パスワード) をハッシュ化した値と、データベース内にあるpassword_digestカラムの値を比較します。
                session[:user_id] = @user.id
                flash[:notice] = "ログインしました"
                if params[:reservation_id] == nil
                    respond_to do |format|
                        format.js { render ajax_redirect_to(root_path)}
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
      
    def logout #ログアウト
        session[:user_id] = nil
        flash[:notice] = "ログアウトしました"
        redirect_to root_path
    end
    
    def guide #非同期でjsを呼ぶ
        @point = @current_user.point
    end

    def edit #アカウント設定
        @user = User.find(@current_user.id)
        if params[:profile].present?
            @profile = true
        end
        if params[:password].present?
            @password = true
        end
        if params[:credit].present?
            @card = UserCard.find_by(user_id: @current_user.id)
            if @card.present?
                Payjp.api_key =ENV['SECRET_KEY'] #秘密鍵
                customer = Payjp::Customer.retrieve(@card.customer_id) #payjpサイトの顧客情報を取得
                @card_information = customer.cards.retrieve(@card.card_id)  #payjpサイトのカード情報を取得
                @credit = true
            else
                @credit = false
            end
        end 
        if params[:current_password].present? && @user.authenticate(params[:current_password])
            @current_password = true
        elsif params[:current_password].present? && @user.authenticate(params[:current_password]) == false || params[:current_password] == ""
            @current_password = false
        end
    end
     
    def update #アカウント設定でプロフィールをupdate
        @user = User.find(@current_user.id)
        if @user.update(user_params)
            flash[:notice] = "プロフィール情報を更新しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(edit_user_path(@current_user.id))}
            end
        else
            validation_message
        end
    end  

    def password_update #アカウント設定でパスワードをupdate
        @user = User.find(@current_user.id)
        if params[:user][:password] == params[:user][:password_confirmation] && 6 <= params[:user][:password].length && params[:user][:password].length <= 20 #update時のvalidationを設定したかったが、設定するとパスワードをupdateせず他のカラムをupdateするときも発動するのでここで記述する
            @user.update(user_params)
            flash[:notice] = "パスワードを更新しました"
            respond_to do |format|
                format.js { render ajax_redirect_to(edit_user_path(@current_user.id)) }
            end
        else
            if params[:user][:password].length <= 5 || params[:user][:password].length >= 21
                @short_long_error = "パスワードは6文字以上20文字以下で入力してください"
            end
            if params[:user][:password] != params[:user][:password_confirmation]
                @match_error = "パスワードが一致しません"
            end
        end
    end
    
    #ここから下はtwitter認証関連
    def twitter_failure #twitter認証に失敗したあとのアクション コールバック
        flash[:notice_red] = "twitterの認証に失敗しました"
        redirect_to root_path
    end

    def twitter #twitter認証に成功した後のアクション コールバック
        @twitter_data = request.env['omniauth.auth'] #この中にtwitterから受け取ったデータが入っている
        @name = @twitter_data["info"]["name"] #twitterアカウントの名前
        @email = @twitter_data["uid"] + "@twitter.com" #twitterのユーザーIDに@twitter.comをつけてメールアドレスとして認識させる
        @user = User.find_by(email: @email, activation_status: true) #emailは実質twitterのユーザーIDなのでそれだけで判定できる twitter側でidは変更できない
        if @user.present? #既にそのtwitterアカウントで登録していたらログインさせる
            flash[:notice] = "ログインしました"
            session[:user_id] = @user.id
            redirect_to root_path
        else #twitterアカウントで登録していなかったら性別を選択させるviewに飛ばす
            session[:twitter_name] = @name
            session[:twitter_email] = @email
            session[:deadline_at] = Time.now + 600
            redirect_to sex_choice_path
        end
    end

    def sex_choice #twitterの認証に成功して性別を選択させる
        @user = User.new
    end

    def twitter_create #twitterを認証し、性別も選択したらデータベースに保存する twitter認証してから10分以内に性別を選択しなくてはいけない
        if params[:user].present? && session[:deadline_at].present? && Time.now <= session[:deadline_at] #twitter認証してから10分以内に性別を選択しないと保存されない
            @user = User.new(user_params)
            @user.name = session[:twitter_name]
            @user.email = session[:twitter_email]
            @user.password = "chokichoki" #乱数化される twitterアカウントで登録する場合user側ではパスワードを設定できないが設定しなくてはバリデーションに引っかかる
            @user.activation_status = true
            if @user.save
                session[:user_id] = @user.id #ログイン状態にする
                flash[:notice] = "登録が完了しました"
                redirect_to root_path 
            else #twitterでのアカウント名がデータベースにある名前と重複する メールアドレスは絶対に重複しない
                flash[:notice_red] = "そのtwitterのアカウントは保存できません。すでに同じ名前のアカウントが存在します。"
                redirect_to root_path 
            end
        else #twitterの認証が終わってから10分たった後に性別を選択した
            flash[:notice_red] = "最初からやり直してください"
            redirect_to root_path
        end
        session[:deadline_at] = nil
    end

    #ここから3つはパスワード再設定の流れ ログインしていない時パスワードを忘れた
    def password_reset #post パスワードを忘れたときにメールを送る
        @email = params[:email]
        @user = User.find_by(email: @email, activation_status: true)
        if @user.present? && @email.include?("twitter") == false #twitterアカウントではない twitterアカウントのパスワード変更はない
            token = SecureRandom.urlsafe_base64
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            digest = BCrypt::Password.create(token, cost: cost)
            @user.password_reset_digest = digest
            @user.password_reset_deadline_at = Time.now + 600
            @user.save
            NotificationMailer.password_reset_mail(@user, token, "user").deliver_now
            @success = true
        else
            @error = true
        end
    end

    def password_update_as_forget #get パスワードを忘れたときに送信されたメールのURLをクリックしたとき
        @token = params[:token]
        @user = User.find_by(email: params[:email])
        @digest = @user.password_reset_digest
        @deadline_at = @user.password_reset_deadline_at
        @true_or_false = BCrypt::Password.new(@digest).is_password?(@token)
        if Time.now <= @deadline_at && @true_or_false
            session[:password_reset_user_id] = @user.id
            session[:password_reset_deadline] = Time.now + 600
        else
            redirect_to deadline_path
        end
    end

    def password_update_when_not_login #patch passwordをupdate パスワード再設定のviewに飛ばされてから10分以内に新しいパスワードを入力しないといけない
        if session[:password_reset_deadline].present? && Time.now <= session[:password_reset_deadline]
            if params[:user][:password] == params[:user][:password_confirmation] && 6 <= params[:user][:password].length && params[:user][:password].length <= 20 #update時のvalidationを設定したかったが、設定するとパスワードをupdateせず他のカラムをupdateするときも発動するのでここで記述する
                @user = User.find(session[:password_reset_user_id])
                @user.update(user_params)
                flash[:notice] = "パスワードを更新しました"
                respond_to do |format|
                    format.js { render ajax_redirect_to(root_path) }
                end
            else
                if params[:user][:password].length <= 5 || params[:user][:password].length >= 21
                    @short_long_error = "パスワードは6文字以上20文字以下で入力してください"
                end
                if params[:user][:password] != params[:user][:password_confirmation]
                    @match_error = "パスワードが一致しません"
                end
            end
        else
            flash[:notice_red] = "要求がタイムアウトになりました。最初からやり直してください。"
            redirect_to root_path
        end
    end

    def validation_message #インスタンスメソッド #バリデーションのメッセージ
        @total_error = @user.errors.messages.length
        if @user.errors.added?(:name, :too_short, :count=>2) || @user.errors.added?(:name, :too_long, :count=>10)
            @error_name_short_long = "名前は2文字以上10文字以下で入力してください"
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
        if @user.errors.added?(:password, :too_short, :count=>6) || @user.errors.added?(:password, :too_long, :count=>20)
            @error_password_short_long = "パスワードは6文字以上20文字以下で入力してください"
        end
        if @user.errors.added?(:password_confirmation, :confirmation, :attribute=>"パスワード")
            @error_password_confirmaiton = "パスワードが一致しません"
        end
        if @user.errors.added?(:sex, :blank)
            @error_sex_blank = "性別を選択してください"
        end
    end

    private
	def user_params
		params.require(:user).permit(:name, :email, :password, :password_confirmation, :sex)
	end

end
