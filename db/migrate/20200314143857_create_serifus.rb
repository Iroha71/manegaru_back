class CreateSerifus < ActiveRecord::Migration[6.0]
  def change
    create_table :serifus do |t|
      t.references :girl, null: false, foreign_key: true
      t.string :situation, null: false
      t.string :message, null: false
      t.string :emotion, null: false
      t.string :voice_path

      t.timestamps
    end
  end
end
