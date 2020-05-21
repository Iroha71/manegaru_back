class ProjectTaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :task_num
  has_many :tasks

  def task_num
    object.tasks.length
  end
end
