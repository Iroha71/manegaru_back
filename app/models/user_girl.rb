class UserGirl < ApplicationRecord
  belongs_to :user
  belongs_to :girl

  validates :user_id, presence: true
  validates :girl_id, presence: true

  INSERT_REQUIRE_PAY = 100

  def self.get_new_girl(current_user, girl_id)
    ActiveRecord::Base.transaction do
      current_user.pay_gold(INSERT_REQUIRE_PAY)
      self.create(user_id: current_user.id, girl_id: girl_id).save!
    end
  end

  def add_like_rate(point, is_current_girl)
    like_rate = is_current_girl ? point : (point * 0.8).floor
    self.like_rate += like_rate
    self.save!
  end
end
