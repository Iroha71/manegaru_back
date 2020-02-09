class CreateGirls < ActiveRecord::Migration[6.0]
  def change
    create_table :girls do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.date :birthday
      t.string :favorite
      t.string :color
      t.string :color2
      t.string :detail

      t.timestamps
    end
  end
end
