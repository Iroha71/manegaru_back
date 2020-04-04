namespace :push_remind do
    desc "リマインダーをLINE BOTに送信する"
    task :line, ['toast_timing'] => :environment do |task, args|
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_BOT_SECRET'],
            config.channel_token = ENV['LINE_BOT_TOKEN']
        }
        @target_users = User.get_notify_task(args[:toast_timing])
        @target_users.each do |user|
            task_list = []
            user.tasks.each_with_index do |task, carousel_count|
                if carousel_count < 10
                    task_list.push(task.create_carousel)
                end
            end
            girl_code = user.girl.code
            message = Girl.get_remind_message(girl_code, user.nickname)
            url = ENV['CLIENT_URL'] + '/task/?openExternalBrowser=1'
            girl_message = { type: 'text', text: message + "\n" + url }
            carousel_message = {
                type: 'template',
                altText: 'タスクリスト',
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
