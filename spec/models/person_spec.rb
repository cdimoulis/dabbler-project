# == Schema Information
#
# Table name: people
#
#  id                  :uuid             not null, primary key
#  prefix              :string
#  first_name          :string
#  middle_name         :string
#  last_name           :string
#  suffix              :string
#  gender              :string
#  birth_date          :date
#  phone               :string
#  address_one         :string
#  address_two         :string
#  city                :string
#  state_region        :string
#  country             :string
#  postal_code         :string
#  facebook_id         :string
#  facebook_link       :string
#  twitter_id          :string
#  twitter_screen_name :string
#  instagram_id        :string
#  instagram_username  :string
#  creator_id          :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require "rails_helper"
include FactoryGirl::Syntax::Methods

RSpec.describe Person do

  context 'associations' do

  end

  context '.save' do
    it 'succeeds' do
      valid_person = build(:person)
      expect(valid_person.save).to be_truthy
    end

    it 'has invalid prefix' do
      invalid_person = build(:person, prefix: 'Str.')
      expect(invalid_person.save).to be_falsy
    end

    it 'has invalid suffix' do
      invalid_person = build(:person, suffix: 'Jrr.')
      expect(invalid_person.save).to be_falsy
    end

    it 'has invalid gender' do
      invalid_person = build(:person, gender: 'malee')
      expect(invalid_person.save).to be_falsy
    end

    it 'has invalid country' do
      invalid_person = build(:person, country: "United Statess", state_region: nil)
      expect(invalid_person.save).to be_falsy
    end

    it 'has invalid state' do
      invalid_person = build(:person, state_region: 'Illinoiss', country: "United States")
      expect(invalid_person.save).to be_falsy
    end

  end
end
