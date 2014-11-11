class UserPageSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :description, :summary, :content, :provider_name, :provider_url,
             :author_name, :published_at, :media_type, :media_html, :media_height, :media_width,
             :image_url, :liked, :liked_at, :saved, :saved_at, :read, :read_at
end
