class RemindMailer < ApplicationMailer
    default from: "noreply@manegaru.com"

    def send_remind_mail(user, message, url_message)
        @user = user
        @message = message
        @url_message = url_message
        mail to: @user.email, subject: "【こんこん】リマインドメール"
    end
end
