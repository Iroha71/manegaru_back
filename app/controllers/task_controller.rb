class TaskController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:show, :update, :update_status]

    def index
        if params[:group_id].present?
            @task = Task.includes(:priority).includes(:project).where(user_id: @current_user.id, project_id: params[:group_id])
        else
            @task = Task.includes(:priority).includes(:project).where(user_id: @current_user.id)
        end
        render status: 200, json: @task
    end

    def show
        render status: :ok, json: @task
    end
    
    def create
        @task = Task.new(get_task_params)
        if @task.save!
            render status: 200, json: @task
        else
            render_faild_save_message()
        end
    end

    def update
        @task.update(get_task_params)
        render json: @task
    end

    def update_status
        @task.update(status: params[:status])
        render status: :ok, json: @task.status
    end

    private
    def get_task_params
        params.permit(:title, :detail, :limit_date, :status, :priority_id, :project_id).merge(user_id: @current_user.id)
    end

    def render_faild_save_message
        render status: 422, json: { 'error': '登録に失敗しました' }
    end

    def set_task
        @task = Task.find(params[:id])
        authorize @task
    end
end
