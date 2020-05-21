class SerifuController < ApplicationController
    before_action :authenticate_user!

    def index
        situations = split_situation_params()
        serifu_set = Serifu.get_serifus(@current_user, params[:girl_id], situations)
        render status: :ok, json: serifu_set
    end

    def show
        @serifu = Serifu.find_by(girl_id: params[:id], situation: params[:situation])
        @serifu = @serifu.replace_user_name(@current_user)
        render status: :ok, json: @serifu
    end

    private
    def split_situation_params
        params[:situation].split(',')
    end
end
