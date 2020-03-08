class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :nickname, :personal_pronoun, :personality, :gold, :is_cooped_line
  belongs_to :girl

  def is_cooped_line
    object.line_id.present?
  end
end
