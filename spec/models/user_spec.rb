require 'rails_helper'

describe User, type: :model do
  context "associations" do
    it "has many memberships dependent on destroy" do
      association = described_class.reflect_on_association(:memberships)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many rooms through memberships dependent on destroy" do
      association = described_class.reflect_on_association(:rooms)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :memberships
      expect(association.options[:dependent]).to eq :destroy
    end

    it "has many recipient with class name Message" do
      association = described_class.reflect_on_association(:messages)
      expect(association.macro).to eq :has_many
      expect(association.options[:as]).to eq :recipient
    end
  end

  context "validations" do
    let(:user) { described_class.new(name: '', email: 'test@example.com', password: '123456') }

    it "validates not presence of name" do
      expect(user).not_to be_valid
    end

    it "validates presence of name" do
      user.name = 'John'
      expect(user).to be_valid
    end
  end
end