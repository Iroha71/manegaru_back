# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :girl, optional: true

  validates :email, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 10 }
  validates :personal_pronoun, presence: true

  def token_validation_response
    UserSerializer.new(self)
  end

  def success_paid_gold?(cost)
    if cost <= self.gold
      self.gold -= cost
      return true
    else
      return false
    end
  end
end
