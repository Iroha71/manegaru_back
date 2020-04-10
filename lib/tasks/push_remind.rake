namespace :push_remind do
    desc "リマインダーをLINE BOTに送信する"
    task :line, ['notify_timing'] => :environment do |task, args|
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_BOT_SECRET'],
            config.channel_token = ENV['LINE_BOT_TOKEN']
        }
        @target_users = User.get_notify_task(args[:notify_timing])
        @target_users.each do |user|
            task_list = []
            next_notifies = { day: [], week: [], month: [] }
            user.tasks.each_with_index do |task, carousel_count|
                if carousel_count < 10
                    task_list.push(task.create_carousel)
                end
                if task.notify_interval.present?
                    key = task.notify_interval.to_sym
                    next_notifies[key].push(task.id)
                end
            end
            Task.set_next_notify_at(next_notifies, user.tasks[0].notify_at)
            girl_code = user.girl.code
            message = Girl.get_remind_message(girl_code, user.nickname)
            url = ENV['CLIENT_URL'] + '/task/?openExternalBrowser=1'
            girl_message = { type: 'text', text: message + "\n" + url }
            carousel_message = {
                type: 'template',
                altText: 'タスクリストが送られてきました',
                template: {
                    type: 'carousel',
                    columns: task_list
                }
            }
            if user.notify_method.eql?('line') && task_list.present? && user.line_id.present?
                response = client.push_message(user.line_id, [girl_message, carousel_message])
                puts "LINEの返却値 #{response.body.to_yaml}"
            elsif user.notify_method.eql?('mail') && task_list.present?
                RemindMailer.send_remind_mail(user, message, url).deliver
            end
        end
    end
end
