class ProjectPolicy < ApplicationPolicy
    def create?
        true
    end

    def index?
        true
    end

    def show?
        record.user_id == user.id
    end

    def update?
        record.user_id == user.id
    end

    def destroy?
        record.user_id == user.id
    end
end