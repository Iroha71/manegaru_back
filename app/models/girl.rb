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

    def self.get_line_reply(girl_code, reply_type, user_nickname)
        serifu = {
            'akane' => {
                'remind' => "やっほー、#{user_nickname}！ 茜やで！ これ、やらなあかんって言いよらんかったか？",
                'finished_task' => "おー！ お疲れさん。終わったやつのタイトル教えてくれんか？",
                'confirm_task_title' => '終わったってのはこれのことなん？',
                'confirm_task_title_other' => 'んじゃ、きっとこれやで',
                'done_task' => 'おっけー！完了にしておいたで！',
                'task_not_found' => 'んー？ それっぽいのないなぁ。',
                'chat_exit' => 'ええんやで！ ほな、また後でな！'
            },
            'aoi' => {
                'remind' => "こんにちは、#{user_nickname}さん。葵です。今すべきことをまとめました。確認してくださいね？",
                'finished_task' => "良かったです。少しだけ心配してましたよ。何ていうタスクですか？",
                'confirm_task_title' => '終わったのはこれですか？',
                'confirm_task_title_other' => 'ほかには…これですか？',
                'done_task' => '分かりました、こちらで処理しておきますね。',
                'task_not_found' => 'えっと、どうやら見つからないみたいです。',
                'chat_exit' => '別にこれくらい大したことないですよ。また何かあったら顔を出してください。'
            },
            'yukari' => {
                'remind' => "お疲れ様です、#{user_nickname}さん。ゆかりですよ。期限が近いタスクを見つけました。注意してくださいね！",
                'finished_task' => "これで管理するものが減りましたね。終わったタスクのタイトルを教えてほしいです！",
                'confirm_task_title' => "#{user_nickname}さんが言っているのはこれですか？",
                'confirm_task_title_other' => 'えっと…あ、これもありました',
                'done_task' => '了解です！ タスクを完了させました。',
                'task_not_found' => 'これ以上は見つかりませんでした。',
                'chat_exit' => 'ふふ、ゆかりさんにとっては朝飯前です！'
            },
            'itako' => {
                'remind' => "#{user_nickname}！ こんこん♪ イタコが用向きをお知らせしますわ。頑張ってくださいませ♪ ",
                'finished_task' => "やりましたわね！ 無事に終わってよかったですわ♪ 済んだ用向きの名前を教えてくださいまし♪",
                'confirm_task_title' => 'それはこちらのことですの？',
                'confirm_task_title_other' => 'ではこちらの方ではありません？',
                'done_task' => 'かしこまりましたわ。後は私にお任せください。うふふ♪',
                'task_not_found' => 'あら、もうありませんわ？ どうしましょう？',
                'chat_exit' => '力になれてよかったですわ。また、部屋にいらしてくださいね♪'
            },
            'hiyori' => {
                'remind' => "#{user_nickname}…お疲れ様。あの、これ予定に入ってたよ。もし終わってたら教えてね。",
                'finished_task' => "そうなんだ…よかったよ。終わった用事は何て名前だった？",
                'confirm_task_title' => 'それってこの用事のこと？',
                'confirm_task_title_other' => 'あとは…これかな？',
                'done_task' => '合っててよかったよー。じゃあ、完了にしておくね。',
                'task_not_found' => 'これ以上ないみたい。',
                'chat_exit' => 'えへへ…このくらい何てことないよ。またね！'
            }
        }
        begin
            return serifu[girl_code][reply_type]
        rescue => exception
            puts exception
            return 'リマインドです'
        end
    end
end
