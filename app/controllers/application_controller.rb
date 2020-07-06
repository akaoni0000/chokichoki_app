class ApplicationController < ActionController::Base
    before_action :set_current_user
    before_action :set_current_hairdresser
    before_action :set_gon
    before_action :set_new
    def set_current_user
      @current_user = User.find_by(id: session[:user_id])
    end

    def set_current_hairdresser 
      @current_hairdresser = Hairdresser.find_by(id: session[:hairdresser_id])
    end

    def set_gon
      gon.key = ENV['KEY']
      gon.user_name_data = User.pluck(:name)  #nameだけを配列で取得
      gon.user_email_data = User.pluck(:email)  #emailだけを配列で取得
    end

    def set_new
      @user = User.new
      @hairdresser = Hairdresser.new
    end

    def force_comment
      if @current_user
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
    
end
