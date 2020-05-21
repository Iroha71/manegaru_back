class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :nickname, :personal_pronoun, :gold, :is_cooped_line, :notify_method
  belongs_to :girl
  has_many :projects

  def is_cooped_line
    object.line_id.present?
  end
end
