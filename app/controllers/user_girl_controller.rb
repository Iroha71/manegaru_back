class UserGirlController < ApplicationController
    before_action :authenticate_user!

    def create
        is_success_paid = false
        ActiveRecord::Base.transaction do
            require_pay = 100
            if @current_user.success_paid_gold?(require_pay)
                @user_girl = UserGirl.new(get_user_girl_params)
                @user_girl.save!
                @current_user.save!
                is_success_paid = true
            end
        end

        if is_success_paid
            redirect_to girl_index_path
        else
            render status: :ok, json: { error: '資金が足りません' }
        end
    end

    private
    def get_user_girl_params
        params.permit(:girl_id).merge(user_id: @current_user.id)
    end
end
