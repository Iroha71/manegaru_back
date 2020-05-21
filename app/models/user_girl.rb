class UserGirl < ApplicationRecord
  belongs_to :user
  belongs_to :girl

  validates :user_id, presence: true
  validates :girl_id, presence: true

  INSERT_REQUIRE_PAY = 100
  MAX_LIKE_RATE = 300
  RELATION = {
    GIRL_FREND: { status: '大好き', range: 100 },
    LOVE: { status: '好き', range: 80 },
    LIKE: { status: '親友', range: 50 },
    FREND: { status: '友達', range: 20 },
    NORMAL: { status: '知り合い', range: 0 }
  }

  def self.get_new_girl(current_user, girl_id)
    ActiveRecord::Base.transaction do
      current_user.pay_gold(INSERT_REQUIRE_PAY)
      self.create(user_id: current_user.id, girl_id: girl_id).save!
    end
  end

  def add_like_rate(point, is_current_girl)
    if MAX_LIKE_RATE <= self.like_rate
      return
    end

    like_rate = is_current_girl ? point : (point * 0.8).floor
    self.like_rate += like_rate
    if self.like_rate > MAX_LIKE_RATE
      self.like_rate = MAX_LIKE_RATE
    end
    self.save!
  end

  def self.get_relation(like_rate_prob)
    result = ''
    RELATION.each do |key, r|
      if like_rate_prob >= r[:range]
        result = r
        break
      end
    end
    result
  end
end
