class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.integer :user_id
      # t.string :type
      t.string :buy_or_sell
      

      t.string :stock_symbol
      t.integer :shares

      t.timestamps
    end
  end
end
