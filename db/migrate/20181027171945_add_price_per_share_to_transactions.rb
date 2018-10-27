class AddPricePerShareToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :price_per_share, :float
  end
end
