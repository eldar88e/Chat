require 'rails_helper'

describe Membership, type: :model do
  context "associations" do
    it "belongs to user with class name User" do
      expect(described_class.reflect_on_association(:user).class_name).to eq 'User'
    end
    it "belongs to room with class name Room" do
      expect(described_class.reflect_on_association(:room).class_name).to eq 'Room'
    end
  end

  context "validations" do
    let(:user) { User.create(name: 'Sender', email: 'test@example.com', password: '123456') }
    let(:room) { Room.create(name: 'First room') }
    let!(:membership) { described_class.create(user_id: user, room_id: room) }
    let(:membership_two) { described_class.create(user_id: user, room_id: room) }

    it "validates uniqueness of user_id scoped to room_id" do
      expect(membership_two).not_to be_valid
    end
  end
end
