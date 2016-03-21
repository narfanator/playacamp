json.array!(@tickets) do |ticket|
  json.extract! ticket, :id, :purchaser, :holder, :held
  json.url ticket_url(ticket, format: :json)
end
