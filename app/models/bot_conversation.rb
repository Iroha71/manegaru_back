class BotConversation < ApplicationRecord

    def self.get_history(line_id)
        @user = self.find_by(line_id: line_id)
        if @user.nil?
            @new_user = self.create(line_id: line_id)
            @new_user.save!
            return @new_user
        else
            return @user
        end
    end
end