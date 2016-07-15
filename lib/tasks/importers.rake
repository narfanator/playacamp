require 'csv'

namespace :importers do
  desc "Imports the camp spreadsheet"
  task :import, [:filename] => :environment do |t, args|
    data = {}
    CSV.foreach(args[:filename], :headers => true, :header_converters => :symbol, :converters => :all) do |row|
      data[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
    end

    data.each do |name, entry|
      if(entry[:email] && user = User.find_by_email(entry[:email].downcase))
        user.update_attributes(
          legacy_camp_score: entry[:score] || 0,
          needed_tickets: entry[:unticketed] + entry[:ticketed],
          status: entry[:status],
        )
      else
        pw = SecureRandom.urlsafe_base64
        user = User.create(
          name: name + " " + entry[:surname],
          email: entry[:email],
          status: entry[:status],
          legacy_camp_score: entry[:score] || 0,
          needed_tickets: entry[:unticketed] + entry[:ticketed],
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
            puts "Issue with #{name} user #{@user} and #{@entry}"
          else
            Ticket.create(
              user: user,
              category: type
            )
          end
        end
      end
    end
  end

end
