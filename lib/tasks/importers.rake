namespace :importers do
  desc "Imports a list of users with a camp score.\nExpecting first line to be colume names.\nExpecting: score,name,name,email"
  task :camp_score_csv, [:filename] => :environment do |t, args|
    entries = File.readlines(args[:filename])[1..-1] # Skip title line, we know the field layout
    entries.each do |entry|
      score = entry.split(",")[0]
      email = (entry.split(",")[3]||"").strip.downcase
      if(email && user = User.find_by_email(email))
        user.update_attribute :legacy_camp_score, score.to_i
        puts "Found #{user.email} set to #{score}"
      else
        puts "Did not find: '#{email}'"
      end
    end
  end

end
