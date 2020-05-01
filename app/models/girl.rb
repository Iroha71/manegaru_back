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

    def self.get_remind_message(girl_code, user_nickname)
        serifu = {
            'akane' => {
                'remind' => "やっほー、#{user_nickname}！ 茜やで！ これ、やらなあかんって言いよらんかったか？"
            },
            'aoi' => {
                'remind' => "こんにちは、#{user_nickname}さん。葵です。今すべきことをまとめました。確認してくださいね？"
            },
            'yukari' => {
                'remind' => "お疲れ様です、#{user_nickname}さん。ゆかりですよ。期限が近いタスクを見つけました。注意してくださいね！"
            },
            'itako' => {
                'remind' => "#{user_nickname}！ こんこん♪ イタコが用向きをお知らせしますわ。頑張ってくださいませ♪ "
            },
            'hiyori' => {
                'remind' => "#{user_nickname}…お疲れ様。あの、これ予定に入ってたよ。もし終わってたら教えてね。"
            }
        }
        begin
            return serifu[girl_code]['remind']
        rescue => exception
            puts exception
            return 'リマインドです'
        end
    end
end
