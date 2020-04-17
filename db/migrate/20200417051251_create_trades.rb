# frozen_string_literal: true

class CreateTrades < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.references :market, null: false, foreign_key: true
      t.decimal :price, null: false
      t.decimal :quantity, null: false
      t.bigint  :traded_at, null: false
      t.boolean :market_maker, null: false, default: false

      t.index %i[market_id traded_at]

      t.timestamps
    end
  end
end
