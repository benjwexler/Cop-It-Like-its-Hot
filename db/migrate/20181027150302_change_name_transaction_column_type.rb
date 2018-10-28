class ChangeNameTransactionColumnType < ActiveRecord::Migration[5.2]
  def change
    # migration didn't work here, as I used incorrect syntax
    # rename_column :transactions, :type, :buy_or_sell
  end
end
