class TaskController < ApplicationController
    before_action :authenticate_user!
    before_action :set_task, only: [:show, :update, :update_status, :destroy]

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
        if @task.status == '完了'
            tasks = [ @task ]
            completed_info = complete_task(tasks)
            @task.destroy()
            puts completed_info.inspect
            render status: :ok, json: { status: @task.status, user: UserSerializer.new(@current_user), gold: completed_info[:gold], like_rate: completed_info[:message] }
        else
            render status: :ok, json: { status: @task.status }
        end
    end

    def update_status_multi
        @tasks = Task.where(id: params[:ids], user_id: @current_user.id)
        @tasks.update_all(status: params[:status])
        if params[:status] == '完了'
            completed_info = complete_task(@tasks)
            @tasks.delete_all()
            render status: :ok, json: { status: '完了', user: UserSerializer.new(@current_user), tasks: completed_info[:leave_tasks], gold: completed_info[:gold], like_rate: completed_info[:message] }
        end
    end

    def destroy
        @task.destroy()
        render status: :ok, json: { result: 'success' }
    end

    def destroy_multi
        @tasks = Task.where(id: params[:ids])
        @tasks.delete_all()
        @leave_tasks = Task.get_all(@current_user.id)
        render status: :ok, json: @leave_tasks
    end

    private
    def get_task_params
        arrange_notify_timing_param()
        if params[:notify_interval].present?
            params[:status] = '作業中'
        end
        params.permit(:id, :title, :detail, :notify_at, :notify_timing, :notify_interval, :status, :priority_id, :project_id)
            .merge(user_id: @current_user.id).merge(girl_id: @current_user.girl_id)
    end

    def arrange_notify_timing_param
        return if params[:notify_timing].nil?
        params[:notify_timing] = params[:notify_at].present? && params[:notify_timing].nil? ? 'morning' : params[:notify_timing]
        if params[:notify_timing].length >= 2
            params[:notify_timing] = 'both'
        else
            params[:notify_timing] = params[:notify_timing].first
        end
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

    def complete_task(tasks)
        given_gold = 0
        plus_like_rate = 0
        plus_like_rate_for_manage_girl = 0
        message = ''
        relation_girl_ids = []
        tasks.each do |task|
            given_gold += task.priority.point
            plus_like_rate += task.priority.like_rate
            plus_like_rate_for_manage_girl += (task.priority.like_rate * 0.8).floor
            if !relation_girl_ids.include?(task.girl_id)
                relation_girl_ids.push(task.girl_id)
            end
        end
        ActiveRecord::Base.transaction do
            @current_user.add_gold(given_gold)
            @update_records = UserGirl.where(user_id: @current_user.id, girl_id: relation_girl_ids)
            @update_records.each do |update_record|
                is_current_girl = update_record.girl_id == @current_user.girl_id
                total_like_rate = is_current_girl ? plus_like_rate : plus_like_rate_for_manage_girl
                update_record.add_like_rate(total_like_rate, is_current_girl)
                message += "【#{update_record.girl.name}】 "
            end
        end
        @leave_tasks = Task.get_all(@current_user.id)
        message += "の好感度が上がりました！"
        return { leave_tasks: @leave_tasks, message: message, gold: given_gold }
    end 
end
