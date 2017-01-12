# == Schema Information
#
# Table name: group_topic_published_entries
#
#  id                 :uuid             not null, primary key
#  group_id           :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe GroupTopicPublishedEntry, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:group) }
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:published_entry) }
  end

  context 'validations' do

    it 'is valid' do
      model_a = build(:group_topic_published_entry)
      model_b = build(:group_topic_published_entry, topic: nil)
      expect(model_a.valid?).to be_truthy
      expect(model_b.valid?).to be_truthy
    end

    it 'errors when invalid topic group' do
      topic = create(:topic)
      model = build(:group_topic_published_entry, topic: topic)
      expect(model.valid?).to be_falsy
    end

    it 'errors when invalid group domain' do
      domain = create(:domain)
      published_entry = create(:published_entry, domain: domain)
      model = build(:group_topic_published_entry, published_entry: published_entry)
      expect(model.valid?).to be_falsy
    end

    it 'errors when types missmatch' do
      featured_group = create(:featured_group)
      tutorial_group = create(:tutorial_group)
      featured_entry = create(:featured_entry, domain: tutorial_group.domain)
      tutorial_entry = create(:tutorial_entry, domain: featured_group.domain)
      featured_model = build(:group_topic_published_entry, published_entry: tutorial_entry, group: featured_group)
      tutorial_model = build(:group_topic_published_entry, published_entry: featured_entry, group: tutorial_group)

      expect(featured_model.valid?).to be_falsy
      expect(tutorial_model.valid?).to be_falsy
    end

  end
end
