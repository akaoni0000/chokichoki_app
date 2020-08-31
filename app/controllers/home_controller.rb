class HomeController < ApplicationController
    def user_top
        @points = Hairdresser.where(judge_status: true).pluck(:reputation_point).max(5)
        @hairdresser_model = Hairdresser
        @i = 1
        @n = 0
        @user_page = "user"
        gon.body = "white"
        gon.fix = "header"
        #binding.pry
        if session[:double] == true
            gon.double = true
            session[:double] = nil
        end
    end

    def hairdresser_top
        @hairdresser_page = "hairdresser"
        gon.body ="white"
        gon.fix = "header"
        gon.display_none = "none"
    end

    def about #aboutページ
    end

    def deadline #URLの有効期限が切れています のページ
    end

end
