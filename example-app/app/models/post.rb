class Post < ApplicationRecord
  has_one_attached :hero

  def to_param
    slug
  end
end
