class CreateHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :histories do |t|
      t.integer :currency
      t.datetime :time
      t.decimal :ask, precision: 13, scale: 8, default: 0.0
      t.decimal :bid, precision: 13, scale: 8, default: 0.0
      t.decimal :last, precision: 13, scale: 8, default: 0.0

      t.timestamps
    end
    add_index :histories, :currency
  end
end
