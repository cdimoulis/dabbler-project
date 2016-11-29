require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "Admin tests"

  context 'associations' do
    it { is_expected.to belong_to(:person) }
  end

  context '.save' do
    it 'suceeds' do
      user = build(:user)
      expect(user.save).to be_truthy
    end

    it 'does not allow duplicate emails' do
      create(:user, email: "test1@dabbler.fyi")
      duplicate = build(:user, email: "test1@dabbler.fyi")
      expect(duplicate.save).to be_falsy
    end

    it 'does not allow invalid user_types' do
      user = build(:user, user_type: 'Dog')
      expect(user.save).to be_falsy
    end

    it 'does not save mismatch password confirmation' do
      user = build(:user, password_confirmation: "abcdefg")
      expect(user.save).to be_falsy
    end

    it 'creates a person model' do
      user = create(:user)
      person = Person.first
      expect(user.person_id).to eq(person.id)
    end

    it 'is admin' do
      user = create(:user_as_admin)
      expect(user.is_admin?).to be_truthy
    end

    it 'person attributes are appropriately linked' do
      user = create(:user)
      current_name = user.person.first_name
      expect(user.first_name).to eq(current_name)
      user.first_name = "Tommy"
      user.save
      person = Person.find(user.person_id)
      expect(user.first_name).to eq(person.first_name)
    end
  end
end
