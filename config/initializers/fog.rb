AWS_CONNECTION = Fog::Storage.new({
  provider: 'AWS',
  aws_access_key_id: ENV['aws_access_key_id'],
  aws_secret_access_key: ENV['aws_secret_access_key'],
  region: 'us-west-1',
  })
  #TODO: Security on this ^^

AWS_BUCKET = AWS_CONNECTION.directories.get(ENV['aws_bucket'])

if ! AWS_BUCKET # The bucket doesn't exist
  AWS_BUCKET = AWS_CONNECTION.directories.create({
    key: ENV['aws_bucket'],
    public: false, # Same as CarrierWave settings
  })
end

# Pull down the dynamic HTML
["_info.html"].each do |filename|
  File.write File.join("public", filename), AWS_BUCKET.files.get(filename).body
end

# Snippets -
# Copies prod to dev -
# PROD_BUCKET = AWS_CONNECTION.directories.get('swingcity3')
# PROD_BUCKET.files.each{|file| AWS_CONNECTION.copy_object 'swingcity3', file.key, ENV['AWS_BUCKET'], file.key, {region: 'us-west-1'}  }
