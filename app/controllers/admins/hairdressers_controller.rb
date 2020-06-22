class Admins::HairdressersController < ApplicationController

    def hairdresser_judge_index
        @hairdressers = Hairdresser.where(status: 0)
    end

    def show
        @hairdresser = Hairdresser.find(params[:id])
    end

    def permit
        @hairdresser = Hairdresser.find(params[:id])
        @hairdresser.status = 1
        @hairdresser.save
        redirect_to admins_hairdresser_judge_index_path
    end

end
