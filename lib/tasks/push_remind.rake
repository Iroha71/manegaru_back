namespace :push_remind do
    desc "リマインダーをLINE BOTに送信する"
    task :line, ['notify_timing'] => :environment do |task, args|
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_BOT_SECRET'],
            config.channel_token = ENV['LINE_BOT_TOKEN']
        }
        current_time = Time.current
        current_hour = "#{current_time.year}-#{current_time.month}-#{current_time.day} #{current_time.hour}:00"
        @target_users = User.get_notify_task(current_hour)
        @target_users.each do |user|
            task_list = []
            next_notifies = { day: [], week: [], month: [] }
            user.tasks.each_with_index do |task, carousel_count|
                if task.notify_interval.present?
                    key = task.notify_interval.to_sym
                    next_notifies[key].push(task.id)
                end
            end
            line_reply_type = 'remind'
            message = Girl.get_line_reply(user.girl.code, line_reply_type, user.nickname)
            url = ENV['CLIENT_URL'] + '/task/?openExternalBrowser=1'
            girl_message = Linebot.get_text(message + "\n" + url)
            carousel_message = Linebot.get_task_carousel(user.tasks)
            if user.notify_method.eql?('line') && carousel_message.present? && user.line_id.present?
                response = client.push_message(user.line_id, [girl_message, carousel_message])
                puts "LINEの返却値 #{response.body.to_yaml}"
            elsif user.notify_method.eql?('mail') && task_list.present?
                RemindMailer.send_remind_mail(user, message, url).deliver
            end
            Task.set_next_notify_at(next_notifies, user.tasks[0].notify_at)
        end
    end
end
