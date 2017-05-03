class User < ActiveRecord::Base
  before_create { generate_token(:auth_token) }
  has_many :camp_scores
  has_secure_password
  mount_uploader :userpic, UserPicUploader
  mount_uploader :bikepic, UserPicUploader
  mount_uploaders :stuffpics, UserPicUploader
  #validates :name, :userpic, presence: true
  validates :name, uniqueness: true
  validates_numericality_of :needed_tickets, only_integer: true, greater_than_or_equal_to: 0
  before_save { |user| user.email = user.email.downcase }
  #after_create :send_password_reset

  has_many :tickets

  def needed_tickets
    #TODO: Refactor this out
    (status == "camper") ? 1 : 0
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def score
    legacy_camp_score + camp_scores.collect{|c| c.score}.inject(0, :+)
  end

  def self.upsert_from_csv_entry entry
    errors = []
    needed_tickets = ((entry[:unticketed] || 0) + (entry[:ticketed] || 0)) || 0
    if(entry[:email] && user = User.find_by_email(entry[:email].downcase))
      user.update_attributes(
        name: "#{entry[:name]} #{entry[:surname]}",
        legacy_camp_score: entry[:score] || 0,
        needed_tickets: needed_tickets,
        status: entry[:status].downcase,
      )
    elsif entry[:name] && entry[:surname] && user = User.find_by_name("#{entry[:name]} #{entry[:surname]}")
      user.update_attributes(
        name: "#{entry[:name]} #{entry[:surname]}",
        legacy_camp_score: entry[:score] || 0,
        needed_tickets: needed_tickets,
        status: entry[:status].downcase,
      )
    else
      pw = SecureRandom.urlsafe_base64
      user = User.create(
        name: "#{entry[:name]} #{entry[:surname]}",
        email: entry[:email].downcase,
        status: entry[:status].downcase,
        legacy_camp_score: entry[:score] || 0,
        needed_tickets: needed_tickets,
        password: pw,
        password_confirmation: pw
      )
    end

    if(entry[:ticketed] && entry[:ticketed] > user.tickets.count)
      (1..(entry[:ticketed] - user.tickets.count)).each do
        type =
          (entry[:direct] and :direct) ||
          (entry[:conclave] and :conclave) ||
          (entry[:low_income] and :low_income) ||
          (entry[:external] and :external) ||
          (entry[:general] and :general)

        @user = user
        @entry = entry
        if user.id == nil
          errors << "Issue with #{name} user #{@user} and #{@entry}"
        else
          Ticket.create(
            user: user,
            category: type
          )
        end
      end
    end

    return errors
  end
end
