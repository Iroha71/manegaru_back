class PrioritySerializer < ActiveModel::Serializer
  attributes :id, :name, :level, :point, :like_rate
end
