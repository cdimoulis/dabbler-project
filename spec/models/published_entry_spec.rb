# == Schema Information
#
# Table name: published_entries
#
#  id               :uuid             not null, primary key
#  author_id        :uuid             not null
#  domain_id        :uuid             not null
#  entry_id         :uuid             not null
#  image_url        :string
#  notes            :text
#  tags             :text             is an Array
#  publishable_id   :uuid
#  publishable_type :string
#  creator_id       :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe PublishedEntry, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:entry) }
  end

  context 'validations' do
    let!(:published_entry) { build(:published_entry) }

    it 'is valid' do
      expect(published_entry.valid?).to be_truthy
    end

    it 'required author to match entry author' do
      user = create(:user)
      published_entry.author_id = user.id
      expect(published_entry.valid?).to be_falsy
    end

    it 'requires domain to exist' do
      published_entry.domain_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(published_entry.valid?).to be_falsy
    end
  end

end
