class UserController < ApplicationController
    before_action :authenticate_user!

    def update
        @current_user.update(get_user_params)
        render status: 200, json: @current_user
    end

    private
    def get_user_params
        params.permit(:id, :girl_id, :line_id)
    end
end
