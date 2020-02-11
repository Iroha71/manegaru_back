class CreatePriorities < ActiveRecord::Migration[6.0]
  def change
    create_table :priorities do |t|
      t.string :name
      t.integer :point
      t.integer :level
      t.integer :like_rate

      t.timestamps
    end
  end
end
