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
    entry["E-mail"] ||= ""
    if(entry["E-mail"] && user = User.find_by_email(entry["E-mail"].downcase))
      user.update_attributes(
        name: entry["Full name"],
        legacy_camp_score: entry["Score"] || 0,
        status: entry["Status"].downcase,
      )
    elsif entry["Full name"] && user = User.find_by_name(entry["Full name"])
      user.update_attributes(
        name: entry["Full name"],
        legacy_camp_score: entry["Score"] || 0,
        status: entry["Status"].downcase,
      )
    elsif entry["Full name"]
      pw = SecureRandom.urlsafe_base64
      user = User.create(
        name: entry["Full name"],
        email: entry["E-mail"].downcase,
        status: entry["Status"].downcase,
        legacy_camp_score: entry["Score"] || 0,
        password: pw,
        password_confirmation: pw
      )
    end

    puts "Error with #{entry}" unless user

    if(user && entry["Ticketed"] == "1" && user.tickets.count == 0)
      type =
        (entry["Direct"] and :direct) ||
        (entry["Conclave"] and :conclave) ||
        (entry["Low Income"] and :low_income) ||
        (entry["External"] and :external) ||
        (entry["General"] and :general)

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

    return errors
  end
end
