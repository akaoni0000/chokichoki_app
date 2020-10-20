class ApplicationController < ActionController::Base

    require "date"   #これでDateクラスが使える
    protect_from_forgery with: :null_session #jsファイルから非同期でコントローラにデータを送るときこれがあるとCSRF保護が無効になり非同期できる 
    
    if Rails.env.test?
        before_action :session_for_test
    end

    before_action :set_current_user
    before_action :set_current_hairdresser
    before_action :set_current_admin
    before_action :admin_reject
    before_action :set_gon
    before_action :double_login_prevent
    before_action :set_new_show
    before_action :notification

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
            redirect_to hairdresser_top_path
        end
    end

    def set_gon
        gon.key = ENV['KEY'] #payjp(クレジットカード)の公開鍵
        if @current_user.present?
            gon.user = true

            #現在のポイント数 レスポンシブで使う
            gon.point = @current_user.point
        end
        if @current_hairdresser.present?
            gon.hairdresser = true
            
            #予約件数 レスポンシブで使う
            @reservations = @current_hairdresser.reservations.where.not(user_id: nil) & @current_hairdresser.reservations.where(start_time: Time.now..Float::INFINITY)
            gon.reservations_number = @reservations.length
        end
        if @current_admin.present?
            gon.admin = true
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

    #通知の数
    def notification
        if @current_hairdresser.present?
            @notice_reservations_number = @current_hairdresser.reservations.where.not(notification_status: true, user_id: nil).length
            @cancel_number = CancelReservation.where(hairdresser_id: @current_hairdresser.id, notification_status: false).length

            @room_id_arry = @current_hairdresser.chats.map {|chat| chat.room_id}
            @message = @room_id_arry.map {|room_id| ChatMessage.where(room_id: room_id, hairdresser_id: nil, notification: false)}
            @message.flatten!
            @unread_number_hairdresser = @message.length

            gon.notice_reservations_number = @notice_reservations_number
            gon.cancel_number = @cancel_number
            gon.unread_number_hairdresser = @unread_number_hairdresser
        end
        if @current_user.present? 
            @room_id_arry = @current_user.chats.map {|chat| chat.room_id}
            @message = @room_id_arry.map {|room_id| ChatMessage.where(room_id: room_id, user_id: nil, notification: false)}
            @message.flatten!
            @unread_number_user = @message.length

            gon.unread_number_user = @unread_number_user 
        end
    end

    def session_for_test
        if params[:not_login]
        elsif params[:user_login]
            session[:user_id] = 1
        elsif params[:hairdresser_login]
            session[:hairdresser_id] = 1
        elsif params[:admin_login]
            session[:admin_id] = 1
        end
    end
end
