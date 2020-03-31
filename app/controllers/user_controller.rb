class UserController < ApplicationController
    before_action :authenticate_user!

    def get_gold
        render status: :ok, json: @current_user.gold
    end

    def update
        @current_user.update(get_user_params)
        render status: 200, json: @current_user
    end

    private
    def get_user_params
        if params[:line_id].present?
            params[:notify_method] = 'line'
        end
        params.permit(:girl_id, :line_id, :notify_method)
    end
end
