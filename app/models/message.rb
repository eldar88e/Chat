class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, polymorphic: true

  validates :content, presence: true, length: { maximum: 1000 }

  scope :between_users, ->(user1, user2) {
    where(recipient_type: 'User')
      .where(
        "(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",
        user1.id, user2.id, user2.id, user1.id
      )
  }
end
