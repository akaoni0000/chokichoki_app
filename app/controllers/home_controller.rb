class HomeController < ApplicationController
    def user_top
        @user = User.new
        gon.user_data = User.pluck(:name)
    end
    def hairdresser_top
    end
    
end
