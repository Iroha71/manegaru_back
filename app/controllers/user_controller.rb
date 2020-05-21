class UserController < ApplicationController
    before_action :authenticate_user!

    def show
        if params[:id].to_i == @current_user.id
            render status: :ok, json: @current_user
        else
            render status: 401, json: { error: 'ユーザ情報が正しくありません' }
        end
    end

    def get_gold
        render status: :ok, json: @current_user.gold
    end

    def update
        if params[:user][:is_first_select].eql?('true')
            UserGirl.get_new_girl(@current_user, params[:user][:girl_id])
        end

        begin
            @current_user.update!(get_user_params)
            render status: 200, json: @current_user
        rescue => exception
            errors = exception.to_s.split(',')
            render status: 422, json: { message: errors }
        end
    end

    private
    def get_user_params
        if params[:line_id].present?
            params[:notify_method] = 'line'
        end
        params.require(:user).permit(:email, :name, :nickname, :personal_pronoun, :girl_id, :line_id, :notify_method)
    end
end
