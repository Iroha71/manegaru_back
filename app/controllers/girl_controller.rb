class GirlController < ApplicationController
    before_action :authenticate_user!

    def index
        @girl = Girl.get_all
        if params[:is_first_select] == 'true'
            render status: 200, json: @girl
        else
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
