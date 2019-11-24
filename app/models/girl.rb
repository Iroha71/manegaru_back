class Girl < ApplicationRecord
    has_many :user_girls

    def get_with_lockinfo(current_user_id)
        is_lock = true
        self.user_girls.each do |user_girl|
            if user_girl.id == current_user_id
                is_lock = false
            end
        end
        girl = { name: self.name, code: self.code, detail: self.detail, is_lock: is_lock }
        return girl
    end
end
