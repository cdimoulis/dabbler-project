# == Schema Information
#
# Table name: published_entries
#
#  id                         :uuid             not null, primary key
#  author_id                  :uuid             not null
#  domain_id                  :uuid             not null
#  entry_id                   :uuid             not null
#  image_url                  :string
#  notes                      :text
#  tags                       :text             is an Array
#  type                       :string
#  data                       :json
#  revised_published_entry_id :uuid
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorialEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      tutorial_entry = create(:tutorial_entry)
      expect(tutorial_entry.type).to eq('TutorialEntry')
    end
  end

  context 'associations' do
    it 'associates updated entries' do
      te_a = create(:tutorial_entry)
      te_b = create(:tutorial_entry)
      te_c = create(:tutorial_entry)
      te_c.revised_tutorial_entry = te_b
      te_c.save
      te_b.revised_tutorial_entry = te_a
      te_b.save
      expect(te_a.revised_tutorial_entry).to eq(nil)
      expect(te_a.previous_tutorial_entry).to eq(te_b)
      expect(te_b.revised_published_entry_id).to eq(te_a.id)
      expect(te_b.previous_tutorial_entry).to eq(te_c)
      expect(te_c.revised_published_entry_id).to eq(te_b.id)
    end
  end

  context 'validations' do
    it 'fails without order' do
      tut_entry = build(:tutorial_entry, data: {})
      expect(tut_entry.valid?).to be_falsy
    end
  end

  context 'destroy' do
    let!(:tutorial_entry) { create(:tutorial_entry) }

    it 'removes revised_tutorial_entry_id from previous' do
      revised = create(:tutorial_entry, revised_tutorial_entry: tutorial_entry)
      tutorial_entry.destroy
      revised.reload
      expect(revised.revised_published_entry_id).to eq(nil)
    end

    it 'links previous and revised tutorial entries' do
      revised = create(:tutorial_entry, revised_tutorial_entry: tutorial_entry)
      previous = create(:tutorial_entry, revised_tutorial_entry: revised)
      revised.destroy
      previous.reload
      expect(previous.revised_published_entry_id).to eq(tutorial_entry.id)
    end
  end
end
