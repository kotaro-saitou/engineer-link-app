class Tag < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :content, presence: true
  
  has_one_attached :image
end
