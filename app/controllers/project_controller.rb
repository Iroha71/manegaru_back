class ProjectController < ApplicationController
    before_action :authenticate_user!
    def index
        @project = Project.where(user_id: @current_user.id)
        render status: 200, json: @project
    end

    def show
        @project = Project.find(params[:id])
        render status: :ok, json: @project
    end

    def create
        begin
            if params[:name].nil?
                raise 'カテゴリ名は必須です'
            end
            project_num = Project.count_same_project(@current_user.id, params[:name])
            @project = Project.new(name: params[:name] + project_num, user_id: @current_user.id)
            @project.save!
            render status: :ok, json: @project
        rescue => exception
            render status: 422, json: { message: exception }
        end
    end

    def update
        @project = Project.where(user_id: @current_user.id, id: params[:id])
        @project.update(get_project_params)
        render status: :ok, json: @project
    end

    private
    def get_project_params
        params.permit(:name).merge(user_id: @current_user.id)
    end
end
