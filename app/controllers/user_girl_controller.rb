class UserGirlController < ApplicationController
    before_action :authenticate_user!

    def index
        @user_girl = UserGirl.where(user_id: @current_user.id)
        render status: :ok, json: @user_girl
    end

    def show
        @user_girl = UserGirl.find(params[:id])
        render status: :ok, json: @user_girl
    end

    def create
        begin
            UserGirl.get_new_girl(@current_user, params[:user_girl][:girl_id])
            redirect_to girl_index_path
        rescue => exception
            render status: 422, json: { message: exception }
        end
    end

    private
    def get_user_girl_params
        params.require(:user_girl).permit(:girl_id).merge(user_id: @current_user.id)
    end
end
