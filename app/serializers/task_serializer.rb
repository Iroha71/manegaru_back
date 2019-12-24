class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :limit_date, :detail, :status, :created_at, :updated_at, :is_updateded
  belongs_to :priority
  belongs_to :project

  def limit_date
    if object.limit_date.present?
      object.limit_date.strftime("%Y年%m月%d日")
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

  def created_at
    object.created_at.strftime("%Y年%m月%d日")
  end

  def updated_at
    object.updated_at.strftime("%Y年%m月%d日")
  end

  def is_updateded
    if object.created_at != object.updated_at
      true
    else
      false
    end
  end
end
