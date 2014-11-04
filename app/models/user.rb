class User < ActiveRecord::Base
  has_many :likes
  has_many :saves
  has_many :visits

  def avatar_url
    "http://avatars.io/gravatar/#{Digest::MD5.hexdigest(email)}"
  end
end
