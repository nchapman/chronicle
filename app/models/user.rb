class User < ActiveRecord::Base
  has_many :likes

  def avatar_url
    "http://avatars.io/gravatar/#{Digest::MD5.hexdigest(email)}"
  end
end
