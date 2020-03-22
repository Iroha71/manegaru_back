# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :girl, optional: true
  has_many :tasks

  validates :email, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 10 }
  validates :personal_pronoun, presence: true

  scope :get_notify_task, -> (toast_timing) { includes([:tasks, :girl]).references(:tasks)
        .where(notify_method: ['line', 'mail'], tasks: { toast_at: Time.current, toast_timing: [toast_timing, 'both'], status: ['未着手', '作業中'] }) }

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
