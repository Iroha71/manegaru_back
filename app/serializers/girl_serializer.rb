class GirlSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :birthday, :favorite, :detail

  def birthday
    object.birthday.strftime("%m月%d日")
  end
end
