class Girl < ApplicationRecord
    has_many :user_girls

    def get_with_lockinfo(current_user_id)
        is_lock = true
        self.user_girls.each do |user_girl|
            if user_girl.user_id == current_user_id
                is_lock = false
            end
        end
        girl = { id: self.id, name: self.name, code: self.code, color: self.color, color2: self.color2, detail: self.detail, is_lock: is_lock }
        return girl
    end
end
