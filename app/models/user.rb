class User < ActiveRecord::Base
  mount_uploader :userpic, UserPicUploader
end
