class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.float :account_balance

      t.timestamps
    end
  end
end
