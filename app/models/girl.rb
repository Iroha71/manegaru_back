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

    def self.get_remind_message(girl_code, user_nickname, remind_body)
        remind_message = ""
        case girl_code
        when 'akane'
            remind_message = "やっほー！ #{user_nickname}♪ 茜やで♪ このタスクがもうすぐやで!!#{remind_body}"
        when 'aoi'
            remind_message = "こんにちは、葵です。これが終わってないようですが終わりそうですか？#{remind_body}"
        else
            remind_message = "リマインドです#{remind_body}"
        end
        return remind_message
    end
end
