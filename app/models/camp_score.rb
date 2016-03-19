class CampScore < ActiveRecord::Base
  belongs_to :user

  def score
    s = 0
    %i(preparation build participation contribution teardown).each do |sym|
      (s += 1) if self[sym]
    end
    s
  end
end
