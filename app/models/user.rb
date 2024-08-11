class User < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :rooms, through: :memberships, dependent: :destroy
  #has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id
  has_many :messages, as: :recipient, dependent: :destroy

  validates :name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
