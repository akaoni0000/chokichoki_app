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

    def force_comment
      @hairdresser_comment = HairdresserComment.find_by(user_id: @current_user.id, rate: nil)
      if @hairdresser_comment.present?
        @start_time = @hairdresser_comment.start_time
        @menu_time = Menu.find(@hairdresser_comment.menu_id).time*60
        @finish_time = @start_time + @menu_time
        if @finish_time < Time.now
          session[:user_id] = nil
          redirect_to edit_hairdresser_comment_path(id: @hairdresser_comment.id, hairdresser_id: @hairdresser_comment.hairdresser_id)
        end
      end
    end
    
end
