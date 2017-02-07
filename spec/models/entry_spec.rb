# == Schema Information
#
# Table name: entries
#
#  id                :uuid             not null, primary key
#  text              :string           not null
#  description       :text
#  author_id         :uuid             not null
#  default_image_url :string
#  content           :text             not null
#  updated_entry_id  :uuid
#  locked            :boolean          default(FALSE)
#  remove            :boolean          default(FALSE)
#  creator_id        :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Entry, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to have_and_belong_to_many(:contributors).class_name('User') }
    it { is_expected.to belong_to(:updated_entry) }
    it { is_expected.to have_one(:previous_entry) }
    it { is_expected.to have_many(:published_entries) }

    it 'associates updated entries' do
      entry_a = create(:entry_with_creator)
      entry_b = create(:entry_with_creator)
      entry_c = create(:entry_with_creator)
      entry_c.updated_entry = entry_b
      entry_c.save
      entry_b.updated_entry = entry_a
      entry_b.save
      expect(entry_a.updated_entry).to eq(nil)
      expect(entry_a.previous_entry).to eq(entry_b)
      expect(entry_b.updated_entry_id).to eq(entry_a.id)
      expect(entry_b.previous_entry).to eq(entry_c)
      expect(entry_c.updated_entry_id).to eq(entry_b.id)
    end
  end

  context 'scopes' do
    it 'shows unpublished' do
      one = create(:entry_with_creator)
      two = create(:entry_with_creator)
      three = create(:entry_with_creator)
      four = create(:entry_with_creator)

      create(:published_entry, entry: two)
      create(:published_entry, entry: four)
      expect(Entry.unpublished.to_a).to match([one,three])
    end
  end

  context '.save' do
    it 'succeeds' do
      entry = build(:entry_with_creator)
      expect(entry.save).to be_truthy
    end

    it 'requires a valid author' do
      entry = build(:entry_without_author)
      expect(entry.valid?).to be_falsy
      entry.author_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(entry.valid?).to be_falsy
    end
  end

  context 'destroy' do
    let!(:entry) { create(:entry_with_creator) }

    it 'removes updated_entry_id from previous' do
      updated = create(:entry_with_creator, updated_entry: entry)
      entry.destroy
      updated.reload
      expect(updated.updated_entry_id).to eq(nil)
    end

    it 'links previous and updated entries' do
      updated = create(:entry_with_creator, updated_entry: entry)
      previous = create(:entry_with_creator, updated_entry: updated)
      updated.destroy
      previous.reload
      expect(previous.updated_entry_id).to eq(entry.id)
    end
  end
end
