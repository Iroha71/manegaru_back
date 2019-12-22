class GirlController < ApplicationController
    before_action :authenticate_user!

    def index
        if params[:is_first_select] == 'true'
            @girl = Girl.all().order(:id)
            render status: 200, json: @girl
        else
            @girl = Girl.includes(:user_girls).references(:user_girls).order(:id)
            result = []
            @girl.each do |g|
                result.push(g.get_with_lockinfo(@current_user.id))
            end
            render status: 200, json: result
        end
    end

    def show
        @girl = Girl.find(params[:id])
        render status: 200, json: @girl
    end
end
