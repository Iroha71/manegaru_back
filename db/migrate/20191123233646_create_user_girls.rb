class CreateUserGirls < ActiveRecord::Migration[6.0]
  def change
    create_table :user_girls do |t|
      t.references :user, null: false, foreign_key: true
      t.references :girl, null: false, foreign_key: true
      t.integer :like_rate, default: 0

      t.timestamps
    end
  end
end
