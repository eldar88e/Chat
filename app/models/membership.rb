class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user_id, presence: { message: "must be present" }
  validates :room_id, presence: { message: "must be present" }
end
