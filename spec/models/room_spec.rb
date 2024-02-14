require 'rails_helper'

describe Room, type: :model do
  context "associations" do
    it "has many recipient with class name Message dependent on destroy" do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq :has_many
      expect(association.options[:as]).to eq :recipient
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many memberships dependent on destroy" do
      association = described_class.reflect_on_association(:memberships)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many users through memberships" do
      association = described_class.reflect_on_association(:users)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :memberships
    end
  end

  context "validations" do
    let(:room) { Room.new }

    it "validates presence of name" do
      expect(room).not_to be_valid
    end

    it "validates uniqueness of name" do
      room.save
      new_room = Room.new(name: room.name)
      expect(new_room).not_to be_valid
    end
  end
end