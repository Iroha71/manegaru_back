namespace :push_remind do
    desc "リマインダーをLINE BOTに送信する"
    task line: :environment do
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_BOT_SECRET'],
            config.channel_token = ENV['LINE_BOT_TOKEN']
        }
        @target_users = 
            User.includes([:tasks, :girl]).references(:tasks)
                .where(tasks: { limit_date: Task.get_limit_tomorrow, status: ['未着手', '作業中'] })
                .where.not(line_id: nil)
        @target_users.each do |user|
            task_list = ""
            user.tasks.each do |task|
                task_list += "\n・#{task.title}"
            end
            girl_code = user.girl.code
            message = Girl.get_remind_message(girl_code, user.nickname, task_list)
            line_message = { type: 'text', text: message }
            url ={ type: 'text', text: ENV['CLIENT_URL'] + 'task?openExternalBrowser=1' } 
            response = client.push_message(user.line_id, [line_message, url])
        end
    end
end
