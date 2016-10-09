json.extract! user, :id, :name, :email, :type, :created_at
json.url user_url(user, format: :json)
