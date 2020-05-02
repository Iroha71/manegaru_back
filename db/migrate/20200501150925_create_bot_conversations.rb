class CreateBotConversations < ActiveRecord::Migration[6.0]
  def change
    create_table :bot_conversations do |t|
      t.string :line_id, null: false
      t.string :stage, null: false, default: 'message_accepting'
      t.integer :task_confirm_count, null: false, default: 0
      t.string :last_accepted_word
    end
  end
end
