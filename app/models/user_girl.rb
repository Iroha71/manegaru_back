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

  def add_like_rate(point, is_current_girl)
    like_rate = is_current_girl ? point : (point * 0.8).floor
    self.like_rate += like_rate
    self.save!
  end
end
