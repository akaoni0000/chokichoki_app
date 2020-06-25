class ApplicationController < ActionController::Base
    before_action :set_current_user
    before_action :set_current_hairdresser
    before_action :set_key
    def set_current_user
      @current_user = User.find_by(id: session[:user_id])
    end

    def set_current_hairdresser 
      @current_hairdresser = Hairdresser.find_by(id: session[:hairdresser_id])
    end

    def set_key
      gon.key = ENV['KEY']
    end
    
end
