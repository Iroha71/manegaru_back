class Girl < ApplicationRecord
    has_many :user_girls
    has_many :serifus

    scope :get_all, -> { all.includes(:user_girls).references(:user_girls).order(:id) }

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
            remind_message = "やっほー、#{user_nickname}！！ 茜やで♪ 明日までにやらなあかん事があるっぽいで！#{remind_body}"
        when 'aoi'
            remind_message = "こんにちは、#{user_nickname}さん。葵です。明日までの用事は終わりそうですか？#{remind_body}"
        when 'yukari'
            remind_message = "お疲れ様です、#{user_nickname}さん。ゆかりですよ。期限が明日のタスクを見つけました。注意してくださいね！ #{remind_body}"
        when 'itako'
            remind_message = "#{user_nickname}! こんこん♪ イタコが期日が近い用向きをお知らせしますわ。頑張ってくださいませ♪ #{remind_body}"
        else
            remind_message = "リマインドです#{remind_body}"
        end
        return remind_message
    end
end
