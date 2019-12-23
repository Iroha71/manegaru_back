class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at

  def created_at
    object.created_at.strftime("%Y年%m月%d日")
  end
end
