class ProjectController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_resource, only: [:show, :update, :destroy]
    def index
        @project = Project.where(user_id: @current_user.id)
        render status: 200, json: @project
    end

    def show
        if params[:is_with_tasks].eql?('true')
            render status: :ok, json: @project, serializer: ProjectTaskSerializer
        else
            render status: :ok, json: @project
        end
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
        begin
            @project.update!(get_project_params)
            render status: :ok, json: @project
        rescue => exception
            render status: 422, json: get_error_array
        end
    end

    def destroy
        begin
            @project.destroy!()
            @projects = Project.where(user_id: @current_user)
            render status: :ok, json: @projects
        rescue => exception
            render status: 422, json: get_error_array(exception)
        end
    end

    private
    def get_project_params
        params.require(:project).permit(:name).merge(user_id: @current_user.id)
    end

    def authorize_resource
        @project = Project.find(params[:id])
        authorize @project
    end

    def get_error_array(exception)
        { message: exception.to_s.split(',') }
    end
end
