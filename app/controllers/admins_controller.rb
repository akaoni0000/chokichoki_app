class AdminsController < ApplicationController

    def user_index
        @users = User.all
    end

    def hairdresser_index
        @hairdressers = Hairdresser.where(status: 1)
    end

    

    def login
        @admin = Admin.find_by(email: params[:email], password_digest: params[:password])
        if @admin.present?
            session[:admin_id] = @admin.id
            redirect_to admins_user_index_path
        else
            @error = "メールアドレスまたはパスワードが間違っています"
            render "admins/login_form"
        end
    end

    def hairdresser_judge_index
        @hairdressers = Hairdresser.where(status: 0, reject_status: nil)
    end

    def permit
        @hairdresser = Hairdresser.find(params[:id])
        @hairdresser.status = 1
        @hairdresser.save
        redirect_to admins_hairdresser_judge_index_path
    end

    def reject_form
        @hairdresser = Hairdresser.find(params[:id])
    end

    def reject
        @hairdresser = Hairdresser.find(params[:id])
        @hairdresser.reject_status = params[:category1] + params[:category2] + params[:category3] + params[:category4]
        @hairdresser.reject_status.to_s
        @hairdresser.save
        redirect_to admins_hairdresser_judge_index_path
    end

    def chart
        @time_arry = []
        i = 6
        7.times do
            @Time = Date.today - i
            @time_arry.push("#{@Time.month}月#{@Time.day}日")
            i -= 1
        end
        @day_arry = @time_arry.to_json.html_safe  #.to_json.html_safeがないと[&quot;大谷&quot;, &quot;吉川&quot;, &quot;メンドーサ&quot;];このような形でjsには表示されてしまう
        
        @user_arry = []
        n = 6
        7.times do
            @users_number = User.where.not(created_at: Date.today - n ..Float::INFINITY).size
            
        end
    end


    def login_form
    end



    def logout
        session[:admin_id] = nil
        redirect_to admins_login_form_path
    end

end


