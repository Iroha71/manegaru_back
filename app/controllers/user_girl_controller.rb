class UserGirlController < ApplicationController
    before_action :authenticate_user!

    def create
        is_success_paid = false
        require_pay = 100
        ActiveRecord::Base.transaction do
            is_success_paid = @current_user.success_paid_gold?(require_pay)
            @current_user.save!
            get_result = UserGirl.get_new_girl(get_user_girl_params, is_success_paid)
            if get_result == 'success'
                redirect_to girl_index_path
            else
                render status: 422, json: { error: '資金が足りません', gold: @current_user.gold }
            end
        end
    end

    private
    def get_user_girl_params
        params.permit(:girl_id).merge(user_id: @current_user.id)
    end
end
