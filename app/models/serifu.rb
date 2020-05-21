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

  def self.get_serifus(current_user, girl_id, situations)
    @serifus = Serifu.where(girl_id: girl_id, situation: situations)
    serifu_set = {}
    @serifus.each do |serifu|
        replaced_name_serifu = serifu.replace_user_name(current_user)
        sefitu_data = { 'text': replaced_name_serifu.message, 'emotion': serifu.emotion }
        serifu_set.store(serifu.situation, sefitu_data)
    end
    serifu_set
  end
end
