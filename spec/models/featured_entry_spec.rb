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
#  order                      :integer
#  published_at               :datetime
#  type                       :string
#  revised_published_entry_id :uuid
#  removed                    :boolean          default(FALSE)
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

RSpec.describe FeaturedEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      featured_entry = create(:featured_entry)
      expect(featured_entry.type).to eq('FeaturedEntry')
    end
  end

  context 'associations' do
    it { is_expected.to belong_to(:revised_featured_entry) }
    it { is_expected.to have_one(:previous_featured_entry) }

    it 'associates updated entries' do
      fe_a = create(:featured_entry)
      fe_b = create(:featured_entry)
      fe_c = create(:featured_entry)
      fe_c.revised_featured_entry = fe_b
      fe_c.save
      fe_b.revised_featured_entry = fe_a
      fe_b.save
      expect(fe_a.revised_featured_entry).to eq(nil)
      expect(fe_a.previous_featured_entry).to eq(fe_b)
      expect(fe_b.revised_published_entry_id).to eq(fe_a.id)
      expect(fe_b.previous_featured_entry).to eq(fe_c)
      expect(fe_c.revised_published_entry_id).to eq(fe_b.id)
    end
  end

  context 'validations' do
    it 'fails without published_at' do
      feat_entry = build(:featured_entry, published_at: nil)
      expect(feat_entry.valid?).to be_falsy
    end
  end

  context 'destroy' do
    let!(:featured_entry) { create(:featured_entry) }

    it 'removes revised_featured_entry_id from previous' do
      revised = create(:featured_entry, revised_featured_entry: featured_entry)
      featured_entry.destroy
      revised.reload
      expect(revised.revised_published_entry_id).to eq(nil)
    end

    it 'links previous and revised featured entries' do
      revised = create(:featured_entry, revised_featured_entry: featured_entry)
      previous = create(:featured_entry, revised_featured_entry: revised)
      revised.destroy
      previous.reload
      expect(previous.revised_published_entry_id).to eq(featured_entry.id)
    end
  end

end
