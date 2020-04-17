# frozen_string_literal: true

class CreateMarkets < ActiveRecord::Migration[6.0]
  def change
    create_table :markets do |t|
      t.string :pair, null: false
      t.string :symbol, null: false

      t.index :pair, unique: true
      t.index :symbol, unique: true

      t.timestamps
    end
  end
end
