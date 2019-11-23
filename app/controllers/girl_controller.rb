class GirlController < ApplicationController
    # before_action :authenticate_user!

    def index
        if params[:is_first_select]
            @girl = Girl.all()
        end
        render status: 200, json: @girl
    end
end
