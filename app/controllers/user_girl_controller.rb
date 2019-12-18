class UserGirlController < ApplicationController
    before_action :authenticate_user!

    def create
        if @current_user.success_paid_gold?(100)
            @user_girl = UserGirl.new(get_user_girl_params)
            @user_girl.save!
            @current_user.save!
            redirect_to girl_index_path
        else
            render status: 200, json: { error: '資金が足りません' }
        end
    end

    private
    def get_user_girl_params
        params.permit(:girl_id).merge(user_id: @current_user.id)
    end
end
