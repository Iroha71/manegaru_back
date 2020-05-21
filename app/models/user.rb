# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :confirmable, :validatable
  include DeviseTokenAuth::Concerns::User
  belongs_to :girl, optional: true
  has_many :tasks
  has_many :projects

  validates :email, uniqueness: { case_sensitive: true }
  validates :name, presence: true, length: { maximum: 20 }
  validates :nickname, presence: true, length: { maximum: 10 }
  validates :personal_pronoun, presence: true

  scope :get_notify_task, -> (notify_at) { includes([:tasks, :girl]).references(:tasks)
        .where(notify_method: ['line', 'mail'], tasks: { notify_at: notify_at, status: ['未着手', '作業中'] }) }
  scope :find_by_line_id, -> (line_id) { includes(:girl).find_by(line_id: line_id) }

  def token_validation_response
    UserSerializer.new(self)
  end

  def pay_gold(cost)
    self.gold -= cost
    if self.gold < 0
      raise '資金が足りません'
    end
    self.save!
  end

  def add_gold(gold)
    self.gold += gold
    self.save!
  end
end
