# frozen_string_literal: true
class CreateDinosaurs < ActiveRecord::Migration[6.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name, null: false
      t.string :species, null: false
      t.references :cage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
