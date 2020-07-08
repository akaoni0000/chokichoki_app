class HairdresserCommentsController < ApplicationController

    def edit 
        @hairdresser_comment = HairdresserComment.find(params[:id])
        @hairdresser = Hairdresser.find(params[:hairdresser_id])
    end
    def update
        if params[:hairdresser_comment][:rate] == ""
            @hairdresser_comment = HairdresserComment.find(params[:id])
            @hairdresser = Hairdresser.find(params[:hairdresser_comment][:hairdresser_id])
            render "edit"
        else
            #美容師の評価を保存する(これまでの評価に今の評価した数字を足す)
            @hairdresser = Hairdresser.find(params[:hairdresser_comment][:hairdresser_id])
            @hairdresser.reputation_point += BigDecimal(params[:hairdresser_comment][:rate]).floor(1).to_f  #文字列の小数を数値にする　to_iだと小数が切り捨てられた
            @hairdresser.save

            @hairdresser_comment = HairdresserComment.find(params[:id])
            @hairdresser_comment.update(hairdresser_comment_params)
            
            session[:user_id] = @hairdresser_comment.user_id
            redirect_to user_path(@hairdresser_comment.user_id)
        end
    end

    def show
    end
    
    def destroy
    end


     private
	 def hairdresser_comment_params
     	params.require(:hairdresser_comment).permit(:rate, :comment)
	 end
end
