class UserGirl < ApplicationRecord
  belongs_to :user
  belongs_to :girl

  validates :user_id, presence: true
  validates :girl_id, presence: true

  def self.get_new_girl(params, is_paid)
    if is_paid  
      @user_girl = self.new(params)
      @user_girl.save! ? 'success' : 'faild'
    else
      'faild'
    end
  end
end
