class Task < ApplicationRecord
  belongs_to :priority
  belongs_to :project
  belongs_to :user
  belongs_to :girl

  validates :title, presence: true, length: { maximum: 50 }
  validates :detail, length: { maximum: 150 }
  validates :priority_id, presence: true
  validates :project_id, presence: true
  validates :user_id, presence: true

  scope :get_all, -> (user_id) { includes([:priority, :girl, :project]).where(user_id: user_id).order(created_at: :desc) }
  scope :get_only_project, -> (user_id, project_id) { includes(:priority).where(user_id: user_id, project_id: project_id).order(created_at: :desc) }
  scope :get_filtered, -> (query) { includes([:priority, :girl, :project]).includes(:project).where(query) }
  scope :get_ordered, -> (query, column, sign) { includes(:priority).includes(:project).where(query).order("#{column} #{sign}") }

  def create_carousel
    title = arrange_carousel_title(self.title)
    has_memo_message = self.detail.present? ? 'メモあり' : 'メモなし'
    text = { text: has_memo_message }
    task_url = ENV['CLIENT_URL'] + "/task/#{ self.id }/?openExternalBrowser=1"
    default_action = { type: 'uri', label: '確認する', uri: task_url }
    action_show_task = { type: "uri", label: "確認する", uri: task_url }
    return {
      title: title,
      text: has_memo_message,
      defaultAction: default_action,
      actions: [ action_show_task ]
    }
  end
  
  def self.set_next_notify_at(update_ids, today)
    tommorow = today + 1.days
    next_week = today + 7.days
    next_month = today + 1.months
    Task.where(id: update_ids[:day]).update_all(notify_at: tommorow)
    Task.where(id: update_ids[:week]).update_all(notify_at: next_week)
    Task.where(id: update_ids[:month]).update_all(notify_at: next_month)
  end

  private
  def arrange_carousel_title(title)
    if title.length > 30
      title = title.slice(0..30) + '…'
    end
    title
  end
end
