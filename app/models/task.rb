class Task < ApplicationRecord
  belongs_to :priority
  belongs_to :project
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :detail, length: { maximum: 150 }
  validates :priority_id, presence: true
  validates :project_id, presence: true
  validates :user_id, presence: true

  scope :get_all, -> (user_id) { includes(:priority).includes(:project).where(user_id: user_id).order(created_at: :desc) }
  scope :get_only_project, -> (user_id, project_id) { includes(:priority).includes(:project).where(user_id: user_id, project_id: project_id).order(created_at: :desc) }
  scope :get_filtered, -> (query) { includes(:priority).includes(:project).where(query) }
  scope :get_ordered, -> (query, column, sign) { includes(:priority).includes(:project).where(query).order("#{column} #{sign}") }
  def self.get_limit_tomorrow
    now = Time.current
    limit_date = now.tomorrow
    return limit_date
  end
end
