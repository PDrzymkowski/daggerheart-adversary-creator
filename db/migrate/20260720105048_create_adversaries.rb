class CreateAdversaries < ActiveRecord::Migration[8.1]
  def change
    create_table :adversaries do |t|
      t.string :name, null: false
      t.integer :tier, null: false
      t.string :adversary_type, null: false
      t.string :type_suffix
      t.text :description
      t.string :motives_tactics
      t.integer :difficulty, null: false
      t.integer :threshold_major
      t.integer :threshold_severe
      t.integer :hp, null: false
      t.integer :stress, null: false
      t.integer :atk, null: false
      t.string :attack_name, null: false
      t.string :attack_range, null: false
      t.string :attack_damage, null: false
      t.string :attack_type
      t.string :experience
      t.boolean :template, null: false, default: false

      t.timestamps
    end
  end
end
