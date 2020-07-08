class HomeController < ApplicationController
    def user_top
        @points = Hairdresser.where(status:1).pluck(:reputation_point).max(5)
        @hairdresser_model = Hairdresser
        @i = 0
        @user_page = "user"
    end
    def hairdresser_top
        @hairdresser_page = "hairdresser"
    end
end
