class NotificationMailer < ApplicationMailer
    default from: 'no-replay@gmail.com'
     
    def registration_complete_mail(user_or_hairdresser_data, token, user_or_hairdresser) #ここのアクション名が大事    mailのviewはnotification_mailerフォルダに アクション名.text.erbと記述する
        @token = token
        if user_or_hairdresser == "user"
            @user = user_or_hairdresser_data
            mail(subject: "chokichokiへの会員登録" ,to: @user.email)
        elsif user_or_hairdresser == "hairdresser"
            @hairdresser = user_or_hairdresser_data
            mail(subject: "chokichokiへの美容師登録" ,to: @hairdresser.email)
        end
    end

    def password_reset_mail(user_or_hairdresser_data, token, user_or_hairdresser)
        @token = token
        if user_or_hairdresser == "user"
            @user = user_or_hairdresser_data
            mail(subject: "chokichokiのパスワード再設定" ,to: @user.email)
        elsif user_or_hairdresser == "hairdresser"
            @hairdresser = user_or_hairdresser_data
            mail(subject: "chokichokiのパスワード再設定" ,to: @hairdresser.email)
        end
    end

end
