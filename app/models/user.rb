class User < ActiveRecord::Base
  mount_uploader :userpic, UserPicUploader
  validates :name, :userpic, presence: true
  validates :name, uniqueness: true
end
