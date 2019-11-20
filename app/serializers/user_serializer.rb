class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :personal_pronoun, :personality
  belongs_to :girl
end
