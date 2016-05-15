class Ticket < ActiveRecord::Base
  belongs_to :user
  has_paper_trail

  def history
    # First "version" is nil, as the record didn't exist, so we want to skip it.
    h = (versions[1..-1] || []).collect{|v| v.reify.user.name if v.reify}
    if h == []
      [(user && user.name)]
    else
      h + [user.name]
    end
  end

  def held
    if user
      (user.tickets[user.needed_tickets..-1] || []).include? self
    else
      false
    end
  end

  def purchaser
    history.first
  end

  def holder
    history.last
  end
end
