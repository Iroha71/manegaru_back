class LinebotController < ApplicationController
    require 'line/bot'
    
    def client
        @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_BOT_SECRET']
            config.channel_token = ENV['LINE_BOT_TOKEN']
        }
    end

    def callback
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
            head :bad_request
        end
        events = client.parse_events_from(body)
        events.each { |event|
            user_id = event['source']['userId']
            puts "ライン#{user_id}"
            case event
            when Line::Bot::Event::Message
                case event.type
                when Line::Bot::Event::MessageType::Text
                    if event.message['text'].eql?('テスト')
                        client.reply_message(event['replyToken'], template)
                    end
                end
            end
        }

        head :ok
    end

    def template
        message = {
            type: 'text',
            text: 'テストです'
        }
    end
end
