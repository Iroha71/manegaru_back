class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false, limit: 50
      t.string :detail, limit: 150
      t.datetime :notify_at
      t.string :notify_interval
      t.references :priority, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :status, default: '未着手'
      t.references :girl, null: false, foreign_key: true

      t.timestamps
    end
  end
end
