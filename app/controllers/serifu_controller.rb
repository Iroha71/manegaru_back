class SerifuController < ApplicationController
    before_action :authenticate_user!

    def index
        situations = split_situation_params()
        @serifus = Serifu.where(girl_id: params[:girl_id], situation: situations)
        serifu_set = {}
        @serifus.each do |serifu|
            replaced_name_serifu = serifu.replace_user_name(@current_user)
            sefitu_data = { 'text': replaced_name_serifu.message, 'emotion': serifu.emotion }
            serifu_set.store(serifu.situation, sefitu_data)
        end
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
