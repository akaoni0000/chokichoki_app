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
            redirect_to root_path
        end
    end

    def set_gon
        gon.key = ENV['KEY'] #payjp(クレジットカード)の公開鍵
        if @current_user.present?
            gon.user = true
        end
        if @current_hairdresser.present?
            gon.hairdresser = true
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
        end
        if @current_user.present? 
            @room_id_arry = @current_user.chats.map {|chat| chat.room_id}
            @message = @room_id_arry.map {|room_id| ChatMessage.where(room_id: room_id, user_id: nil, notification: false)}
            @message.flatten!
            @unread_number_user = @message.length
        end
    end
    
end
