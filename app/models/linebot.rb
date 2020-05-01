class Linebot < ApplicationRecord

    def self.get_task_carousel(tasks)
        task_columns = []
        tasks.each_with_index do |task, count|
            break if count > 10
            has_memo_text = task.detail.present? ? 'メモあり' : 'メモなし'
            task_uri = ENV['CLIENT_URL'] + "/task/#{ task.id }/?openExternalBrowser=1"
            actions = [ { type: 'uri', label: '確認する', uri: task_uri } ]
            column = create_carousel_column(task.title, has_memo_text, actions)
            task_columns.push(column)
        end
        if task_columns.nil?
            nil
        else
            carousel = {
                type: 'template',
                altText: 'タスクリストが送られてきました',
                template: {
                    type: 'carousel',
                    columns: task_columns
                }
            }
        end
    end

    def self.get_text(text)
        message = {
            type: 'text',
            text: text
        }
    end

    def self.get_reply_message(user_id, message_from_user)
        @user = User.find_by_line_id(user_id)
        return if @user.nil?

        case message_from_user
        when message.include?("終わった")
            reaction_message = get_text()
        end
    end

    private
    def self.arrange_text_length(text, text_limit)
        if text.length > text_limit
        text = text.slice(0..text_limit) + '…'
        end
        text
    end

    def self.create_carousel_column(title, text, actions)
        column = {
          title: arrange_text_length(title, 30),
          text: arrange_text_length(text, 50),
          defaultAction: actions[0],
          actions: actions
        }
    end
end
