json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :phone, :userpic
  json.url user_url(user, format: :json)
end
