class User < ActiveRecord::Base
  has_many :user_pages
  has_many :visits
  has_many :pages, through: :user_pages

  def avatar_url
    "http://avatars.io/gravatar/#{Digest::MD5.hexdigest(email)}"
  end
end
