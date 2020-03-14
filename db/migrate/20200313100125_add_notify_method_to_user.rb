class AddNotifyMethodToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notify_method, :string, default: 'nothing', after: :line_id
  end
end
