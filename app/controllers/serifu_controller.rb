class SerifuController < ApplicationController
    def show
        @serifu = Serifu.find_by(girl_id: params[:id], situation: params[:situation])
        render status: :ok, json: @serifu.message
    end
end
