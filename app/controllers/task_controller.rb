class TaskController < ApplicationController
    before_action :authenticate_user!
    
    def create
        @task = Task.new(get_task_params)
        if @task.save!
            render status: 200, json: @task
        else
            render status: 422, json: { 'error': '登録に失敗しました' }
        end
    end

    private
    def get_task_params
        params.permit(:title, :detail, :limit_date, :status, :priority_id, :project_id).merge(user_id: @current_user.id)
    end
end
