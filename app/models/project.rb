class Project < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :user_id, presence: true

  def self.count_same_project(user_id, project_name)
    same_project = self.where("user_id = #{user_id} and name like '%#{project_name}%'")
    if same_project.empty?
      return ''
    else
      return same_project.length.to_s
    end
  end

  def self.create_default_project(user_id)
    @project = self.new(name: 'やること', user_id: user_id)
    @project.save! ? 'success' : 'faild'
  end
  
  def count_have_tasks
    self.tasks.length
  end
end
