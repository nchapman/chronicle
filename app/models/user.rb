class User < ActiveRecord::Base
  def avatar_url
    "http://avatars.io/gravatar/#{Digest::MD5.hexdigest(email)}"
  end
end
