class Room < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :messages, as: :recipient
  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
end
