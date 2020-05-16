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
        project_number = ''
        begin
            if params[:name].present?
                project_number = Project.count_same_project(@current_user.id, params[:name])
            end
            @project = Project.new(name: params[:name] + project_number, user_id: @current_user.id)
            @project.save!
            render json: :ok, json: @project
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
        params.require(:project).permit(:name).merge(user_id: @current_user.id)
    end
end
