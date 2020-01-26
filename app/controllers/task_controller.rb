class TaskController < ApplicationController
    before_action :authenticate_user!

    def index
        if params[:group_id].present?
            @task = Task.includes(:priority).includes(:project).where(user_id: @current_user.id, project_id: params[:group_id])
        else
            @task = Task.includes(:priority).includes(:project).where(user_id: @current_user.id)
        end
        render status: 200, json: @task
    end

    def show
        @task = Task.includes(:priority).includes(:project).find_by(user_id: @current_user.id, id: params[:id])
        if @task
            render status: 200, json: @task
        else
            render status: 404, json: { error: 'このタスクは存在しません' }
        end
    end
    
    def create
        @task = Task.new(get_task_params)
        if @task.save!
            render status: 200, json: @task
        else
            render_faild_save_message()
        end
    end

    private
    def get_task_params
        params.permit(:title, :detail, :limit_date, :status, :priority_id, :project_id).merge(user_id: @current_user.id)
    end

    def render_faild_save_message
        render status: 422, json: { 'error': '登録に失敗しました' }
    end
end
