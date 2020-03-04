class GirlSerializer < ActiveModel::Serializer
  attributes :id, :name, :code, :birthday, :favorite, :color, :color2, :detail

  def birthday
    object.birthday.strftime("%m月%d日")
  end
end
