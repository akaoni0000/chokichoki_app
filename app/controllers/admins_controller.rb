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
    end


    def login_form
    end



    def logout
        session[:admin_id] = nil
        redirect_to admins_login_form_path
    end

end


