class ApplicationController < ActionController::Base

    require "date"   #これでDateが使える
    protect_from_forgery with: :null_session #jsファイルから非同期でコントローラにデータを送るときこれがあるとCSRF保護が無効になり非同期できる

    before_action :set_current_user
    before_action :set_current_hairdresser
    before_action :set_current_admin
    before_action :admin_reject
    before_action :set_gon
    before_action :set_new_show
    before_action :set_reservation_notification
    before_action :force_comment

    def set_current_user
      @current_user = User.find_by(id: session[:user_id])    #find(session[])とすると必ずsessionに値がなければならない
    end

    def set_current_hairdresser 
      @current_hairdresser = Hairdresser.find_by(id: session[:hairdresser_id])
    end

    def set_current_admin
      @current_admin = Admin.find_by(id: session[:admin_id])
    end

    def admin_reject
      @admin_reject_hairdresser = Hairdresser.find_by(id: session[:reject_id])
      if @admin_reject_hairdresser.present?
        @admin_reject_hairdresser.destroy
        session[:reject_id] = nil
      end
    end

    def set_gon
      gon.key = ENV['KEY']
      gon.user_name_data = User.pluck(:name)  #nameだけを配列で取得
      gon.user_email_data = User.pluck(:email)  #emailだけを配列で取得
      gon.hairdresser_name_data = Hairdresser.pluck(:name)  #nameだけを配列で取得
      gon.hairdresser_email_data = Hairdresser.pluck(:email)  #emailだけを配列で取得
      gon.user = @current_user
    end

    def set_new_show
      @user = User.new
      @hairdresser = Hairdresser.new
    end

    def set_reservation_notification
      if session[:update] == "please_reservation_notification_update"
        @notice_reservations = @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil)
        @notice_reservations.update_all(:notification_status => 1 )
        session[:update] = nil
      end
      if session[:cancel_update] == "please_reservation_notification_cancel_update"
        @user_cancel = UserCancel.where(hairdresser_id: @current_hairdresser.id, notification_status: 0)
        @user_cancel.update_all(:notification_status => 1 )
        session[:cancel_update] = nil
      end
      if @current_hairdresser
        @notice_reservations_number = @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil).length
        @cancel_number = UserCancel.where(hairdresser_id: @current_hairdresser.id, notification_status: 0).length
      end
    end
    
    #美容室で施術が終わった時間以降にログインするとコメント画面へ移行する
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
