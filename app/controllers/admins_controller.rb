class AdminsController < ApplicationController

    def user_index
        @users = User.all
    end

    def hairdresser_index
        @hairdressers = Hairdresser.where(status: 1)
    end
   
    def login_form
        if @current_admin.present?
            redirect_to admins_user_index_path
        end
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
        @hairdresser.save!
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

    def user_chart
        #週間会員数推移
        if params[:pre_week_index]
            @week_index_standard = Date.new(params[:pre_week_index][0,4].to_i, params[:pre_week_index][5,2].to_i, params[:pre_week_index][8,2].to_i)
            @week_index_standard -= 7
        elsif params[:next_week_index]
            @week_index_standard = Date.new(params[:next_week_index][0,4].to_i, params[:next_week_index][5,2].to_i, params[:next_week_index][8,2].to_i)
            @week_index_standard += 7
        else
            @week_index_standard = Date.today.end_of_week
        end
        @time_week_index_arry = []
        @user_week_index_arry = []
        i = 4
        5.times do
            @Time_week_index = @week_index_standard - i*7
            @time_week_index_arry.push("#{@Time_week_index.month}月#{@Time_week_index.day}日")
            @users_number = User.where.not(created_at: Time.local((@Time_week_index+1).year, (@Time_week_index+1).month, (@Time_week_index+1).day)..Float::INFINITY).size 
            @user_week_index_arry.push(@users_number)
            i -= 1
        end
        @time_week_index_arry_update = @time_week_index_arry.to_json.html_safe
        @user_week_index_arry_update = @user_week_index_arry.to_json.html_safe
        
        #月間会員数推移
        if params[:pre_month_index]
            @month_index_standard = Date.new(params[:pre_month_index][0,4].to_i, params[:pre_month_index][5,2].to_i, params[:pre_month_index][8,2].to_i).months_ago(1).end_of_month
        elsif params[:next_month_index]
            @month_index_standard = Date.new(params[:next_month_index][0,4].to_i, params[:next_month_index][5,2].to_i, params[:next_month_index][8,2].to_i).months_since(1).end_of_month
        else
            @month_index_standard = Date.today.end_of_month
        end
        @time_month_index_arry = []
        @user_month_index_arry = []
        i = 3
        4.times do
            @Time_month_index = @month_index_standard.months_ago(i)
            @time_month_index_arry.push("#{@Time_month_index.year}年#{@Time_month_index.month}月")
            @users_number = User.where.not(created_at: Time.local((@Time_month_index+1).year, (@Time_month_index+1).month, (@Time_month_index+1).day)..Float::INFINITY).size 
            @user_month_index_arry.push(@users_number)
            i -= 1
        end
        @time_month_index_arry_update = @time_month_index_arry.to_json.html_safe
        @user_month_index_arry_update = @user_month_index_arry.to_json.html_safe

        #新規会員登録者数推移(日別)
        if params[:pre_day]
            @day_standard = Date.new(params[:pre_day][0,4].to_i, params[:pre_day][5,2].to_i, params[:pre_day][8,2].to_i)
            @day_standard -= 7
        elsif params[:next_day]
            @day_standard = Date.new(params[:next_day][0,4].to_i, params[:next_day][5,2].to_i, params[:next_day][8,2].to_i)
            @day_standard += 7
        else
            @day_standard = Date.today
        end
        @time_day_arry = []
        @user_day_arry = []
        i = 6
        7.times do
            @Time_day = @day_standard - i
            @time_day_arry.push("#{@Time_day.month}月#{@Time_day.day}日")
            @users_number = User.where(created_at: Time.local(@Time_day.year, @Time_day.month, @Time_day.day).all_day).size 
            @user_day_arry.push(@users_number)
            i -= 1
        end
        @time_day_arry_update = @time_day_arry.to_json.html_safe
        @user_day_arry_update = @user_day_arry.to_json.html_safe


        #週間新規会員登録者数推移
        if params[:pre_week]
            @week_standard = Date.new(params[:pre_week][0,4].to_i, params[:pre_week][5,2].to_i, params[:pre_week][8,2].to_i)
            @week_standard -= 7
        elsif params[:next_week]
            @week_standard = Date.new(params[:next_week][0,4].to_i, params[:next_week][5,2].to_i, params[:next_week][8,2].to_i)
            @week_standard += 7
        else
            @week_standard = Date.today.beginning_of_week
        end
        @time_week_arry = []
        @user_week_arry = []
        i = 3
        4.times do
            @Time_week = @week_standard - i*7
            @time_week_arry.push("#{@Time_week.month}月#{@Time_week.day}日~#{(@Time_week + 6).month}月#{(@Time_week + 6).day}日")
            @users_number = User.where(created_at: Time.local(@Time_week.year, @Time_week.month, @Time_week.day).all_week).size #dateでall_weekやall_monthをつかうと最後の日が範囲に入らなかった 例 7月20日0時 ~ 7月25日23時59分
            @user_week_arry.push(@users_number)
            i -= 1
        end
        @time_week_arry_update = @time_week_arry.to_json.html_safe
        @user_week_arry_update = @user_week_arry.to_json.html_safe

        #月間新規会員登録者数推移
        if params[:pre_month]
            @month_standard = Date.new(params[:pre_month][0,4].to_i, params[:pre_month][5,2].to_i, params[:pre_month][8,2].to_i).months_ago(1)
        elsif params[:next_month]
            @month_standard = Date.new(params[:next_month][0,4].to_i, params[:next_month][5,2].to_i, params[:next_month][8,2].to_i).months_since(1)
        else
            @month_standard = Date.today
        end
        @time_month_arry = []
        @user_month_arry = []
        i = 3
        4.times do
            @Time_month = @month_standard.months_ago(i)
            @time_month_arry.push("#{@Time_month.year}年#{@Time_month.month}月")
            @users_number = User.where(created_at: Time.local(@Time_month.year, @Time_month.month, @Time_month.day).all_month).size 
            @user_month_arry.push(@users_number)
            i -= 1
        end
        @time_month_arry_update = @time_month_arry.to_json.html_safe
        @user_month_arry_update = @user_month_arry.to_json.html_safe
    end

    def sell_chart
        #売り上げ推移(日別)
        if params[:pre_day]
            @day_standard = Date.new(params[:pre_day][0,4].to_i, params[:pre_day][5,2].to_i, params[:pre_day][8,2].to_i)
            @day_standard -= 7
        elsif params[:next_day]
            @day_standard = Date.new(params[:next_day][0,4].to_i, params[:next_day][5,2].to_i, params[:next_day][8,2].to_i)
            @day_standard += 7
        else
            @day_standard = Date.today
        end
        @time_day_arry = []
        @money_day_arry = []
        i = 6
        7.times do
            @Time_day = @day_standard - i
            @time_day_arry.push("#{@Time_day.month}月#{@Time_day.day}日")
            @money_number = Money.where(created_at: Time.local(@Time_day.year, @Time_day.month, @Time_day.day).all_day).size * 500
            @money_day_arry.push(@money_number)
            i -= 1
        end
        @time_day_arry_update = @time_day_arry.to_json.html_safe
        @money_day_arry_update = @money_day_arry.to_json.html_safe

        #週間売り上げ推移
        if params[:pre_week]
            @week_standard = Date.new(params[:pre_week][0,4].to_i, params[:pre_week][5,2].to_i, params[:pre_week][8,2].to_i)
            @week_standard -= 7
        elsif params[:next_week]
            @week_standard = Date.new(params[:next_week][0,4].to_i, params[:next_week][5,2].to_i, params[:next_week][8,2].to_i)
            @week_standard += 7
        else
            @week_standard = Date.today.beginning_of_week
        end
        @time_week_arry = []
        @money_week_arry = []
        i = 3
        4.times do
            @Time_week = @week_standard - i*7
            @time_week_arry.push("#{@Time_week.month}月#{@Time_week.day}日~#{(@Time_week + 6).month}月#{(@Time_week + 6).day}日")
            @money_number = Money.where(created_at: Time.local(@Time_week.year, @Time_week.month, @Time_week.day).all_week).size * 500 
            @money_week_arry.push(@money_number)
            i -= 1
        end
        @time_week_arry_update = @time_week_arry.to_json.html_safe
        @money_week_arry_update = @money_week_arry.to_json.html_safe


        #月間売り上げ推移
         if params[:pre_month]
            @month_standard = Date.new(params[:pre_month][0,4].to_i, params[:pre_month][5,2].to_i, params[:pre_month][8,2].to_i).months_ago(1)
        elsif params[:next_month]
            @month_standard = Date.new(params[:next_month][0,4].to_i, params[:next_month][5,2].to_i, params[:next_month][8,2].to_i).months_since(1)
        else
            @month_standard = Date.today
        end
        @time_month_arry = []
        @money_month_arry = []
        i = 3
        4.times do
            @Time_month = @month_standard.months_ago(i)
            @time_month_arry.push("#{@Time_month.year}年#{@Time_month.month}月")
            @money_number = Money.where(created_at: Time.local(@Time_month.year, @Time_month.month, @Time_month.day).all_month).size * 500
            @money_month_arry.push(@money_number)
            i -= 1
        end
        @time_month_arry_update = @time_month_arry.to_json.html_safe
        @money_month_arry_update = @money_month_arry.to_json.html_safe


        #週間総売り上げ推移
        if params[:pre_week_index]
            @week_index_standard = Date.new(params[:pre_week_index][0,4].to_i, params[:pre_week_index][5,2].to_i, params[:pre_week_index][8,2].to_i)
            @week_index_standard -= 7
        elsif params[:next_week_index]
            @week_index_standard = Date.new(params[:next_week_index][0,4].to_i, params[:next_week_index][5,2].to_i, params[:next_week_index][8,2].to_i)
            @week_index_standard += 7
        else
            @week_index_standard = Date.today.end_of_week
        end
        @time_week_index_arry = []
        @money_week_index_arry = []
        i = 4
        5.times do
            @Time_week_index = @week_index_standard - i*7
            @time_week_index_arry.push("#{@Time_week_index.month}月#{@Time_week_index.day}日")
            @money_number = Money.where.not(created_at: Time.local((@Time_week_index+1).year, (@Time_week_index+1).month, (@Time_week_index+1).day)..Float::INFINITY).size * 500
            @money_week_index_arry.push(@money_number)
            i -= 1
        end
        @time_week_index_arry_update = @time_week_index_arry.to_json.html_safe
        @money_week_index_arry_update = @money_week_index_arry.to_json.html_safe

        #月間総売り上げ推移
        if params[:pre_month_index]
            @month_index_standard = Date.new(params[:pre_month_index][0,4].to_i, params[:pre_month_index][5,2].to_i, params[:pre_month_index][8,2].to_i).months_ago(1)
        elsif params[:next_month_index]
            @month_index_standard = Date.new(params[:next_month_index][0,4].to_i, params[:next_month_index][5,2].to_i, params[:next_month_index][8,2].to_i).months_since(1)
        else
            @month_index_standard = Date.today.end_of_month
        end
        @time_month_index_arry = []
        @money_month_index_arry = []
        i = 3
        4.times do
            @Time_month_index = @month_index_standard.months_ago(i)
            @time_month_index_arry.push("#{@Time_month_index.year}年#{@Time_month_index.month}月")
            @money_number = Money.where.not(created_at: Time.local((@Time_month_index+1).year, (@Time_month_index+1).month, (@Time_month_index+1).day)..Float::INFINITY).size * 500
            @money_month_index_arry.push(@money_number)
            i -= 1
        end
        @time_month_index_arry_update = @time_month_index_arry.to_json.html_safe
        @money_month_index_arry_update = @money_month_index_arry.to_json.html_safe

    end

    def hairdresser_chart
        #週間会員数推移
        if params[:pre_week_index]
            @week_index_standard = Date.new(params[:pre_week_index][0,4].to_i, params[:pre_week_index][5,2].to_i, params[:pre_week_index][8,2].to_i)
            @week_index_standard -= 7
        elsif params[:next_week_index]
            @week_index_standard = Date.new(params[:next_week_index][0,4].to_i, params[:next_week_index][5,2].to_i, params[:next_week_index][8,2].to_i)
            @week_index_standard += 7
        else
            @week_index_standard = Date.today.end_of_week
        end
        @time_week_index_arry = []
        @hairdresser_week_index_arry = []
        i = 4
        5.times do
            @Time_week_index = @week_index_standard - i*7
            @time_week_index_arry.push("#{@Time_week_index.month}月#{@Time_week_index.day}日")
            @hairdresser_number = Hairdresser.where.not(created_at: Time.local((@Time_week_index+1).year, (@Time_week_index+1).month, (@Time_week_index+1).day)..Float::INFINITY, status: 0).size 
            @hairdresser_week_index_arry.push(@hairdresser_number)
            i -= 1
        end
        @time_week_index_arry_update = @time_week_index_arry.to_json.html_safe
        @hairdresser_week_index_arry_update = @hairdresser_week_index_arry.to_json.html_safe
        
        #月間会員数推移
        if params[:pre_month_index]
            @month_index_standard = Date.new(params[:pre_month_index][0,4].to_i, params[:pre_month_index][5,2].to_i, params[:pre_month_index][8,2].to_i).months_ago(1).end_of_month
        elsif params[:next_month_index]
            @month_index_standard = Date.new(params[:next_month_index][0,4].to_i, params[:next_month_index][5,2].to_i, params[:next_month_index][8,2].to_i).months_since(1).end_of_month
        else
            @month_index_standard = Date.today.end_of_month
        end
        @time_month_index_arry = []
        @hairdresser_month_index_arry = []
        i = 3
        4.times do
            @Time_month_index = @month_index_standard.months_ago(i)
            @time_month_index_arry.push("#{@Time_month_index.year}年#{@Time_month_index.month}月")
            @hairdresser_number = Hairdresser.where.not(created_at: Time.local((@Time_month_index+1).year, (@Time_month_index+1).month, (@Time_month_index+1).day)..Float::INFINITY, status: 0).size 
            @hairdresser_month_index_arry.push(@hairdresser_number)
            i -= 1
        end
        @time_month_index_arry_update = @time_month_index_arry.to_json.html_safe
        @hairdresser_month_index_arry_update = @hairdresser_month_index_arry.to_json.html_safe

        #新規会員登録者数推移(日別)
        if params[:pre_day]
            @day_standard = Date.new(params[:pre_day][0,4].to_i, params[:pre_day][5,2].to_i, params[:pre_day][8,2].to_i)
            @day_standard -= 7
        elsif params[:next_day]
            @day_standard = Date.new(params[:next_day][0,4].to_i, params[:next_day][5,2].to_i, params[:next_day][8,2].to_i)
            @day_standard += 7
        else
            @day_standard = Date.today
        end
        @time_day_arry = []
        @hairdresser_day_arry = []
        i = 6
        7.times do
            @Time_day = @day_standard - i
            @time_day_arry.push("#{@Time_day.month}月#{@Time_day.day}日")
            @hairdresser_number = Hairdresser.where(created_at: Time.local(@Time_day.year, @Time_day.month, @Time_day.day).all_day, status: 1).size 
            @hairdresser_day_arry.push(@hairdresser_number)
            i -= 1
        end
        @time_day_arry_update = @time_day_arry.to_json.html_safe
        @hairdresser_day_arry_update = @hairdresser_day_arry.to_json.html_safe


        #週間新規会員登録者数推移
        if params[:pre_week]
            @week_standard = Date.new(params[:pre_week][0,4].to_i, params[:pre_week][5,2].to_i, params[:pre_week][8,2].to_i)
            @week_standard -= 7
        elsif params[:next_week]
            @week_standard = Date.new(params[:next_week][0,4].to_i, params[:next_week][5,2].to_i, params[:next_week][8,2].to_i)
            @week_standard += 7
        else
            @week_standard = Date.today.beginning_of_week
        end
        @time_week_arry = []
        @hairdresser_week_arry = []
        i = 3
        4.times do
            @Time_week = @week_standard - i*7
            @time_week_arry.push("#{@Time_week.month}月#{@Time_week.day}日~#{(@Time_week + 6).month}月#{(@Time_week + 6).day}日")
            @hairdresser_number = Hairdresser.where(created_at: Time.local(@Time_week.year, @Time_week.month, @Time_week.day).all_week, status: 1).size #dateでall_weekやall_monthをつかうと最後の日が範囲に入らなかった 例 7月20日0時 ~ 7月25日23時59分
            @hairdresser_week_arry.push(@hairdresser_number)
            i -= 1
        end
        @time_week_arry_update = @time_week_arry.to_json.html_safe
        @hairdresser_week_arry_update = @hairdresser_week_arry.to_json.html_safe

        #月間新規会員登録者数推移
        if params[:pre_month]
            @month_standard = Date.new(params[:pre_month][0,4].to_i, params[:pre_month][5,2].to_i, params[:pre_month][8,2].to_i).months_ago(1)
        elsif params[:next_month]
            @month_standard = Date.new(params[:next_month][0,4].to_i, params[:next_month][5,2].to_i, params[:next_month][8,2].to_i).months_since(1)
        else
            @month_standard = Date.today
        end
        @time_month_arry = []
        @hairdresser_month_arry = []
        i = 3
        4.times do
            @Time_month = @month_standard.months_ago(i)
            @time_month_arry.push("#{@Time_month.year}年#{@Time_month.month}月")
            @hairdresser_number = Hairdresser.where(created_at: Time.local(@Time_month.year, @Time_month.month, @Time_month.day).all_month, status: 1).size 
            @hairdresser_month_arry.push(@hairdresser_number)
            i -= 1
        end
        @time_month_arry_update = @time_month_arry.to_json.html_safe
        @hairdresser_month_arry_update = @hairdresser_month_arry.to_json.html_safe
    end

    def logout
        session[:admin_id] = nil
        redirect_to root_path
    end

end


