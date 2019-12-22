class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :nickname, :personal_pronoun, :personality, :gold
  belongs_to :girl
end
