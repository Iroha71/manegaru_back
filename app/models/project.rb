class Project < ApplicationRecord
  belongs_to :user

  def self.count_same_project(user_id, project_name)
    same_project = self.where("user_id = #{user_id} and name like '%#{project_name}%'")
    if same_project.empty?
      return ''
    else
      return same_project.length.to_s
    end
  end
end
