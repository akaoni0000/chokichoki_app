class HomeController < ApplicationController
    def user_top
        @points = Hairdresser.where(status:1).pluck(:reputation_point).max(5)
        @hairdresser_model = Hairdresser
        @i = 1
        @n = 0
        @user_page = "user"
        gon.body = "white"
        gon.fix = "header"
    end
    def hairdresser_top
        @hairdresser_page = "hairdresser"
        gon.body ="white"
        gon.fix = "header"
    end
end
