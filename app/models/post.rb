class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 200 }
  
  def self.search(search)
    Post.all unless search
    Post.where(['content LIKE ?', "%#{search}%"])
  end
  
end
