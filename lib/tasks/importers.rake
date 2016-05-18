namespace :importers do
  desc "Imports a list of users with a camp score.\nExpecting first line to be colume names.\nExpecting: score,name,name,email"
  task :camp_score_csv, [:filename] => :environment do |t, args|
    entries = File.readlines(args[:filename])[1..-1] # Skip title line, we know the field layout
    entries.each do |entry|
      score = entry.split(",")[0].to_i
      email = (entry.split(",")[3]||"").strip.downcase
      if(email && user = User.find_by_email(email))
        user.update_attribute :legacy_camp_score, score
        puts "Found #{user.email} set to #{score}"
      else
        if(score > 0)
          puts "Entry not found: #{entry}. Create?"
          if(STDIN.gets.strip == 'y')
            pw = SecureRandom.urlsafe_base64
            User.create(
              name: (entry.split(',')[1] + " " + entry.split(',')[2]),
              email: email,
              legacy_camp_score: score,
              password: pw,
              password_confirmation: pw
            )
            puts "User created"
          else
            puts "User not created"
          end
        end
      end
    end
  end

end
