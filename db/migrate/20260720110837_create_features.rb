class CreateFeatures < ActiveRecord::Migration[7.2]
  def change
    create_table :features do |t|
      t.references :adversary, null: false, foreign_key: true
      t.string :name, null: false
      t.string :feature_type, null: false
      t.text :description, null: false
      t.integer :position, null: false, default: 0

      t.timestamps
    end
  end
end
