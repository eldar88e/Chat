class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, polymorphic: true

  validates :content, presence: true, length: { maximum: 1000 }
end
