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

    def self.get_task_confirm_carousel(task, girl_reaction_text)
        carousel = {
            type: 'template',
            altText: 'タスク確認フォーム',
            template: {
                type: 'confirm',
                text: girl_reaction_text + "\n【#{task.title}】",
                actions: [
                    {
                        type: 'message',
                        label: 'そう',
                        text: 'そう'
                    },
                    {
                        type: 'message',
                        label: '違うよ',
                        text: '違うよ'
                    }
                ] 
            }
        }
    end

    def self.get_text(text)
        message = {
            type: 'text',
            text: text
        }
    end

    def self.get_reply_message(user_id, message_from_user)
        message_accepting = 'message_accepting'
        task_confirming = 'task_confirming'
        
        @user = User.find_by_line_id(user_id)
        return if !@user.present?

        @bot_reply = BotConversation.get_history(@user.line_id)
        if @bot_reply.stage.eql?(message_accepting)
            if message_from_user.include?('終わった') || message_from_user.include?('おわった')
                @bot_reply.update(stage: task_confirming)
                reply_type = 'finished_task'
                return get_text(Girl.get_line_reply(@user.girl.code, reply_type, @user.nickname))
            elsif message_from_user.include?('ありがと')
                return get_text(Girl.get_line_reply(@user.girl.code, 'chat_exit', @user.nickname))
            else
                return get_text('無効な値')
            end
        end

        if @bot_reply.stage.eql?(task_confirming) && message_from_user.include?('ありがと')
            @bot_reply.update(stage: message_accepting, task_confirm_count: 0)
            return get_text(Girl.get_line_reply(@user.girl.code, 'chat_exit', @user.nickname))
        end

        if !@bot_reply.stage.eql?(task_confirming)
            return get_text('無効な値')
        end

        case message_from_user
        when '違うよ'
            question_count = @bot_reply.task_confirm_count
            @bot_reply.update(task_confirm_count: question_count + 1)
            return get_confirm_task_reply(@bot_reply.last_accepted_word, 'confirm_task_title_other')
        when 'そう'
            target_index = @bot_reply.task_confirm_count
            @tasks = Task.search_by_title(@user.id, @bot_reply.last_accepted_word)
            completed_info = Task.complete(@user, [ @tasks[target_index].id ])
            @bot_reply.update(stage: message_accepting, task_confirm_count: 0)
            return get_text(Girl.get_line_reply(@user.girl.code, 'done_task', @user.nickname))
        else
            #ユーザがタスクタイトルを言ったとき
            if !@bot_reply.stage.eql?(task_confirming)
                return get_text('無効な値')
            end
            @bot_reply.update(last_accepted_word: message_from_user)
            return get_confirm_task_reply(message_from_user, 'confirm_task_title')
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

    def self.get_confirm_task_reply(title_keyword, reply_type)
        @tasks = Task.search_by_title(@user.id, title_keyword)
        question_count = @bot_reply.task_confirm_count
        if question_count >= @tasks.length
            @bot_reply.update(task_confirm_count: 0)
            task_not_found_message = Girl.get_line_reply(@user.girl.code, 'task_not_found', @user.nickname)
            return get_text(task_not_found_message)
        end
        girl_text = Girl.get_line_reply(@user.girl.code, reply_type, @user.nickname)
        return get_task_confirm_carousel(@tasks[question_count], girl_text)
    end
end
