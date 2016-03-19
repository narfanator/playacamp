json.array!(@camp_scores) do |camp_score|
  json.extract! camp_score, :id, :preparation, :build, :participation, :contribution, :teardown
  json.url camp_score_url(camp_score, format: :json)
end
