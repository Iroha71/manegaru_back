class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name, :task_num, :created_at

  def created_at
    object.created_at.strftime("%Y年%m月%d日")
  end

  def task_num
    object.count_have_tasks()
  end
end
