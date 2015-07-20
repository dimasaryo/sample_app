class Micropost < ActiveRecord::Base

  validates :content, presence: true,
                      length: { within: 1..140 }
  validates :user_id, presence: true
  
  belongs_to :user
  
end
