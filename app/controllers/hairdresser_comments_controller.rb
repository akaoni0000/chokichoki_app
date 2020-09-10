class HairdresserCommentsController < ApplicationController

    def edit 
        if session[:comment_id].present?
            @hairdresser_comment = HairdresserComment.find(params[:id])
            @hairdresser = Hairdresser.find(params[:hairdresser_id])
        else
            redirect_to root_path
        end
    end

    def update
        @hairdresser_comment = HairdresserComment.find(session[:comment_id])
        if @hairdresser_comment.update(hairdresser_comment_params)
            #美容師の評価を保存する(これまでの評価に今の評価した数字を足す)
            @hairdresser = Hairdresser.find(@hairdresser_comment.hairdresser_id)
            @hairdresser.reputation_point += BigDecimal(params[:hairdresser_comment][:rate]).floor(1).to_f  #文字列の小数を数値にする　to_iだと小数が切り捨てられた
            @hairdresser.save
    
            #評価をつけたuserには200ポイントあげる
            @user = User.find(@hairdresser_comment.user_id)
            @user.point += 200
            @user.save
            
            #他にもまだ評価をつけていないものを探す
            @hairdresser_comment = HairdresserComment.order(start_time: "ASC").find_by(user_id: @user.id, rate: nil)
            if @hairdresser_comment.present?
                @start_time = @hairdresser_comment.start_time
                @menu_time = @hairdresser_comment.menu.time*60
                @finish_time = @start_time + @menu_time 
                if @finish_time < Time.now
                    session[:comment_id] = @hairdresser_comment.id
                    redirect_to edit_hairdresser_comment_path(id: @hairdresser_comment.id, hairdresser_id: @hairdresser_comment.hairdresser_id)
                else
                    session[:comment_id] = nil
                    session[:user_id] = @user.id
                    flash[:notice] = "ログインしました"
                    redirect_to root_path
                end
            else
                session[:comment_id] = nil
                session[:user_id] = @user.id
                flash[:notice] = "ログインしました"
                redirect_to root_path
            end
        else
            @hairdresser_comment = HairdresserComment.find(session[:comment_id])
            @hairdresser = Hairdresser.find(@hairdresser_comment.hairdresser_id)
            @error = "星をクリックして評価をつけてください"
            render "edit"
        end
    end

    def index
        @hairdresser_comments = @current_hairdresser.hairdresser_comments.order(start_time: "DESC")
    end

    private
	def hairdresser_comment_params
     	params.require(:hairdresser_comment).permit(:rate, :comment)
    end

end
