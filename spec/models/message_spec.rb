require 'rails_helper'

describe Message, type: :model do
  context "associations" do
    it "belongs to sender with class name User" do
      expect(described_class.reflect_on_association(:sender).class_name).to eq 'User'
    end

    it "belongs to recipient as polymorphic" do
      expect(described_class.reflect_on_association(:recipient).options[:polymorphic]).to be true
    end
  end

  context "validations" do
    let(:user) { User.create(name: 'Sender', email: 'test@example.com', password: '123456') }
    let(:user2) { User.create(name: 'Recipient', email: 'test2@example.com', password: '123456') }
    let(:message) { described_class.new(sender: user, recipient: user2, content: 'Hello!') }

    it "validates presence of content" do
      message.content = nil
      expect(message).not_to be_valid
    end

    it "validates maximum length of content" do
      message.content = 'a' * 1001
      expect(message).not_to be_valid
    end
  end
end