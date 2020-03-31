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
            give_user_gold = 0
            message = ''
            ActiveRecord::Base.transaction do
                give_user_gold = @task.priority.point
                plus_like_rate = @task.priority.like_rate 
                @current_user.add_gold(give_user_gold)
                @target_girls = UserGirl.where(user_id: @current_user.id, girl_id: [@current_user.girl_id, @task.girl_id])
                @target_girls.each do |target_girl|
                    is_current_girl = target_girl.girl_id == @current_user.girl_id
                    target_girl.add_like_rate(plus_like_rate, is_current_girl)
                    message += "【#{target_girl.girl.name}】 "
                end
                @task.destroy()
            end
            message += 'の好感度が上がりました!'
            render status: :ok, json: { user: UserSerializer.new(@current_user), gold: give_user_gold, like_rate: message }
        else
            render status: :ok, json: { status: @task.status }
        end
    end

    def update_status_multi
        @tasks = Task.where(id: params[:ids], user_id: @current_user.id)
        @tasks.update_all(status: params[:status])
        if params[:status] == '完了'
            give_user_gold = 0
            plus_like_rate = 0
            plus_like_rate_for_manage_girl = 0
            relation_girl_ids = []
            message = ''
            @tasks.each do |task|
                give_user_gold += task.priority.point
                plus_like_rate += task.priority.like_rate
                plus_like_rate_for_manage_girl += (task.priority.like_rate * 0.8).floor
                if !relation_girl_ids.include?(task.girl_id)
                    relation_girl_ids.push(task.girl_id)
                end
            end
            ActiveRecord::Base.transaction do
                @current_user.add_gold(give_user_gold)
                @target_girls = UserGirl.where(user_id: @current_user.id, girl_id: relation_girl_ids)
                @target_girls.each do |user_girl|
                    total_like_rate = user_girl.girl_id == @current_user.girl_id ? plus_like_rate : plus_like_rate_for_manage_girl
                    user_girl.add_like_rate(total_like_rate, true)
                    message += "【#{user_girl.girl.name}】 "
                end
            end
            @tasks.delete_all()
            @leave_tasks = Task.get_all(@current_user.id)
            message += "の好感度が上昇しました!"
            render status: :ok, json: { user: UserSerializer.new(@current_user), tasks: @leave_tasks, gold: give_user_gold, like_rate: message }
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
        arrange_toast_timing_param()
        params.permit(:id, :title, :detail, :toast_at, :toast_timing, :status, :priority_id, :project_id)
        .merge(user_id: @current_user.id).merge(girl_id: @current_user.girl_id)
    end

    def arrange_toast_timing_param
        return if params[:toast_timing].nil?
        params[:toast_timing] = params[:toast_at].present? && params[:toast_timing].nil? ? 'morning' : params[:toast_timing]
        if params[:toast_timing].length >= 2
            params[:toast_timing] = 'both'
        else
            params[:toast_timing] = params[:toast_timing].first
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
end
