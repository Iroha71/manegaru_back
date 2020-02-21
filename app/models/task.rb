class Task < ApplicationRecord
  belongs_to :priority
  belongs_to :project
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :detail, length: { maximum: 150 }
  validates :priority_id, presence: true
  validates :project_id, presence: true
  validates :user_id, presence: true

  def self.get_limit_tomorrow
    now = Time.current
    limit_date = now.tomorrow
    return limit_date
  end
end
