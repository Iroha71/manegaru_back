class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :notify_at, :notify_at_short, :notify_at_en, :notify_timing, :notify_interval, :is_notified, :detail, :status, :updated_at, :is_updated
  belongs_to :priority
  belongs_to :project
  belongs_to :girl

  def notify_at
    if object.notify_at.present?
      object.notify_at.strftime("%Y年%m月%d日")
    else
      'なし'
    end
  end

  def notify_interval
    case object.notify_interval
    when 'day':
      '毎日'
    when 'week':
      '毎週'
    when 'month':
      '毎月'
    end
  end

  def notify_at_short
    if object.notify_at.present?
      object.notify_at.strftime("%m/%d")
    else
      'なし'
    end
  end

  def notify_at_en
    if object.notify_at.present?
      object.notify_at
    else
      nil
    end
  end

  def detail
    if object.detail.nil?
      'なし'
    else
      object.detail
    end
  end

  def is_notified
    if object.notify_at.present? && object.notify_at < Date.current
      true
    else
      false
    end
  end

  def updated_at
    object.updated_at.strftime("%Y年%m月%d日")
  end

  def is_updated
    if object.created_at != object.updated_at
      true
    else
      false
    end
  end
end
