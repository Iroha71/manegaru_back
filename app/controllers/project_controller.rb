class ProjectController < ApplicationController
    before_action :authenticate_user!
    def index
        @project = Project.where(user_id: @current_user.id)
        render status: 200, json: @project
    end

    def create
        project_num = Project.count_same_project(@current_user.id, params[:name])
        @project = Project.new(name: params[:name] + project_num, user_id: @current_user.id)
        if @project.save!
            render status: 200, json: @project
        else
            render status: 422, json: { error: '登録に失敗しました' }
        end
    end

    private
    def get_project_params
        params.permit(:name).merge(user_id: @current_user.id)
    end
end
