class TaskPolicy < ApplicationPolicy

    def index?
        Task.where(user_id: user.id)
    end
    
    def show?
        record.user_id == user.id
    end

    def update?
       record.user_id == user.id
    end

    def update_status?
        record.user_id == user.id
    end

end