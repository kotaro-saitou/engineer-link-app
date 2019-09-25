class Message < ApplicationRecord
  belongs_to :from, class_name: 'User'
  belongs_to :to, class_name: 'User'
  
  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :room_id, presence: true
  validates :content, presence: true, length: {maximum: 150}
  
  def Message.room_id_message(room_id)
    where(room_id: room_id).last(200)
  end
end
