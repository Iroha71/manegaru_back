class UserGirl < ApplicationRecord
  belongs_to :user
  belongs_to :girl

  def self.get_new_girl(params, is_paid)
    if is_paid  
      @user_girl = self.new(params)
      @user_girl.save! ? 'success' : 'faild'
    else
      'faild'
    end
  end
end
