json.extract! transaction, :id, :user_id, :type, :stock_symbol, :shares, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
