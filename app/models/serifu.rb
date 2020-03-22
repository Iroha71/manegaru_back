class Serifu < ApplicationRecord
  belongs_to :girl

  def replace_user_name(user)
    if self.message.index('マスター')
      self.message = self.message.gsub!(/マスター/u, user.nickname)
      self
    else
      self
    end
  end
end
