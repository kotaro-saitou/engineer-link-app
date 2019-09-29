class Tag < ApplicationRecord
  belongs_to :user
  
  validates :title, presence: true
  validates :content, presence: true
  
  has_one_attached :image
  
  has_many :tag_relations, dependent: :destroy
  has_many :added_user, through: :tag_relations, source: :user
end
