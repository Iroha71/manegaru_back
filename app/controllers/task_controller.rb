class TaskController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:show, :update, :destroy]

    STATUS = { YET: '未着手', WORKING: '作業中', FINISHED: '完了' }

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

    def show
        render status: :ok, json: @task
    end
    
    def create
        begin
            @task = Task.new(get_task_params)
            @task.save!
            render status: :ok, json: @task
        rescue => exception
            render status: 422, json: { message: exception }
        end   
    end

    def update
        @task.update(get_task_params)
        render json: @task
    end

    def update_status
        if params[:status] == STATUS[:FINISHED]
            ids = [ params[:id] ]
            completed_info = Task.complete(@current_user, ids)
            render status: :ok, json: { status: STATUS[:FINISHED], user: UserSerializer.new(@current_user), gold: completed_info[:gold], like_rate: completed_info[:message] }
        else
            set_task()
            @task.update(status: params[:status])
            render status: :ok, json: { status: @task.status }
        end
    end

    def update_status_multi
        if params[:status] == STATUS[:FINISHED]
            completed_info = Task.complete(@current_user, params[:ids])
            if params[:project_id].present?
                @leave_tasks = Task.get_only_project(@current_user.id, params[:project_id])
            else
                @leave_tasks = Task.get_all(@current_user.id)
            end
            render status: :ok, json: { status: STATUS[:FINISHED], user: UserSerializer.new(@current_user), tasks: @leave_tasks, gold: completed_info[:gold], like_rate: completed_info[:message] }
        end
    end

    def destroy
        @task.destroy()
        render status: :ok, json: { result: 'success' }
    end

    def destroy_multi
        Task.where(id: params[:ids]).delete_all()
        if params[:project_id].present?
            @leave_tasks = Task.get_only_project(@current_user.id, params[:project_id])
        else
            @leave_tasks = Task.get_all(@current_user.id)
        end
        render status: :ok, json: @leave_tasks
    end

    private
    def get_task_params
        if params[:notify_interval].present?
            params[:status] = STATUS[:WORKING]
        end
        if params[:notify_at].nil?
            params[:notify_interval] = nil
        end
        params.permit(:id, :title, :detail, :notify_at, :notify_interval, :status, :priority_id, :project_id)
            .merge(user_id: @current_user.id).merge(girl_id: @current_user.girl_id)
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
