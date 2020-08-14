class ApplicationController < ActionController::Base

    require "date"   #これでDateクラスが使える
    protect_from_forgery with: :null_session #jsファイルから非同期でコントローラにデータを送るときこれがあるとCSRF保護が無効になり非同期できる

    before_action :set_current_user
    before_action :set_current_hairdresser
    before_action :set_current_admin
    before_action :admin_reject
    before_action :set_gon
    before_action :double_login_prevent
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
      if session[:reject_id]
        session[:reject_id] = nil
        redirect_to root_path
      end
    end

    def set_gon
      gon.key = ENV['KEY']
      if @current_user.present?
        gon.user_id = @current_user.id
      end
      if @current_hairdresser.present?
        gon.hairdresser_id = @current_hairdresser.id
      end
    end

    def double_login_prevent
      #二重ログイン防止
      if @current_user.present? && @current_admin.present?
        session[:user_id] = nil
        session[:admin_id] = nil
        session[:double] = true
        redirect_to root_path
      end
      if @current_hairdresser.present? && @current_admin.present?
        session[:hairdresser_id] = nil
        session[:admin_id] = nil
        session[:double] = true
        redirect_to root_path
      end
      if @current_hairdresser.present? && @current_user.present?
        session[:hairdresser_id] = nil
        session[:user_id] = nil
        session[:double] = true
        redirect_to root_path
      end
    end

    def set_new_show
      @user_new = User.new
      @hairdresser_new = Hairdresser.new
    end

    #通知機能
    def set_reservation_notification
      if @current_hairdresser.present?
        @notice_reservations_number = @current_hairdresser.reservations.where.not(notification_status: 1, user_id: nil).length
        @cancel_number = CancelReservation.where(hairdresser_id: @current_hairdresser.id, notification_status: 0).length
      end
    end
    
    #美容室で施術が終わった時間以降にログインするとコメント画面へ移行する
    def force_comment
      if @current_user.present?
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
