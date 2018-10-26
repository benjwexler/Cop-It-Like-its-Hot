class AddDefaultValueAccountBalance < ActiveRecord::Migration[5.2]
  def change
    change_column_default(:users, :account_balance, 5000.00)
  end
end
