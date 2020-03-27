class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :toast_at, :toast_at_short, :toast_timing, :is_notified, :detail, :status, :updated_at, :is_updated
  belongs_to :priority
  belongs_to :project

  def toast_at
    if object.toast_at.present?
      object.toast_at.strftime("%Y年%m月%d日")
    else
      'なし'
    end
  end

  def toast_at_short
    if object.toast_at.present?
      object.toast_at.strftime("%m/%d")
    else
      'なし'
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
    if object.toast_at.present? && object.toast_at < Date.current
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
