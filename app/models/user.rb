class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships
  #has_many :user_messages, foreign_key: :recipient_id, class_name: 'Message'
  has_many :messages, as: :recipient

  validates :name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
