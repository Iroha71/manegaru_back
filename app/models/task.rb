class Task < ApplicationRecord
  belongs_to :prioriry
  belongs_to :project
  belongs_to :user
end
