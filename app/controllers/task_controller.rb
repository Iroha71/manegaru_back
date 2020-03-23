class TaskController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:show, :update, :update_status]

    def index
        if params[:group_id].present?
            @task = Task.get_only_project(@current_user.id, params[:group_id])
        else
            @task = Task.get_all(@current_user.id)
        end
        render status: 200, json: @task
    end

    def custom
        base_query = set_base_query(params)
        if params[:order_column].present?
            @task = Task.get_filtered(base_query).order("#{params[:order_column]} #{params[:order_sign]}")
        else
            @task = Task.get_filtered(base_query)
        end
        render status: :ok, json: @task
    end

    def count_not_finish_tasks
        yet_tasks = Task.where(user_id: @current_user.id, status: '未着手').length
        working_tasks = Task.where(user_id: @current_user.id, status: '作業中').length
        render status: :ok, json: { 'yet': yet_tasks, 'working': working_tasks  }
    end

    def show
        render status: :ok, json: @task
    end
    
    def create
        params[:toast_timing] = params[:toast_at].present? && params[:toast_timing].nil? ? 'morning' : params[:toast_timing]
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
        params.permit(:title, :detail, :toast_at, :toast_timing, :status, :priority_id, :project_id).merge(user_id: @current_user.id)
    end

    def render_faild_save_message
        render status: 422, json: { 'error': '登録に失敗しました' }
    end

    def set_task
        @task = Task.find(params[:id])
        authorize @task
    end

    def set_base_query(params)
        base_query = "user_id = #{@current_user.id}"
        base_query += params[:group_id].present? ? " and project_id = #{params[:group_id]}" : ''
        base_query += params[:column].present? ? " and #{params[:column]} #{params[:sign]} #{params[:value]}" : ''
        return base_query
    end
end
