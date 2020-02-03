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

    def filtered_index
        filter_query = set_base_query(params)
        filter_query = filter_query + " and #{params[:filter_column]} #{params[:filter_sign]} #{params[:filter_value]}"
        @task = Task.includes(:priority).includes(:project).where(filter_query)
        render status: :ok, json: @task
    end

    def ordered_index
        filter_query = set_base_query(params)
        order_query = "#{params[:order_column]} #{params[:order_sign]}"
        @task = Task.includes(:priority).includes(:project).where(filter_query).order(order_query)
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

    def set_base_query(params)
        base_query = "user_id = #{@current_user.id}"
        if params[:group_id].present?
            base_query += " and project_id = #{params[:group_id]}"
        end
        return base_query
    end
end
