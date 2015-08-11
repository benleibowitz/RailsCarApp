class CreateModifications < ActiveRecord::Migration
  def change
    create_table :modifications do |t|
      t.string :name
      t.integer :price
      t.references :car, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
