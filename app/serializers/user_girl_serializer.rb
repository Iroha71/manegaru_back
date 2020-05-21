class UserGirlSerializer < ActiveModel::Serializer
  attributes :id, :like_rate, :relation_status
  belongs_to :girl

  def relation_status
    prog = like_progress()
    relation = UserGirl.get_relation(prog)
    relation[:status]
  end

  private
  def like_progress
    rate = (object.like_rate.to_f / UserGirl::MAX_LIKE_RATE.to_f) * 100
    rate.to_i
  end
end
