# == Schema Information
#
# Table name: users
#
#  id                 :uuid             not null, primary key
#  email              :string           not null
#  encrypted_password :string(128)      not null
#  confirmation_token :string(128)
#  remember_token     :string(128)      not null
#  locked_at          :datetime
#  last_sign_in_ip    :inet
#  last_sign_in_at    :datetime
#  user_type          :string
#  person_id          :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe User, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:person) }
  end

  context '.save' do
    it 'succeeds' do
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
