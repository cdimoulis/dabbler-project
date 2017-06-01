# == Schema Information
#
# Table name: menu_group_published_entry_topics
#
#  id                 :uuid             not null, primary key
#  menu_group_id      :uuid             not null
#  topic_id           :uuid
#  published_entry_id :uuid             not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe MenuGroupPublishedEntryTopic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:menu_group) }
    it { is_expected.to belong_to(:topic) }
    it { is_expected.to belong_to(:published_entry) }
  end

  context 'validations' do

    it 'is valid' do
      model_a = build(:menu_group_published_entry_topic)
      model_b = build(:menu_group_published_entry_topic, topic: nil)
      expect(model_a.valid?).to be_truthy
      expect(model_b.valid?).to be_truthy
    end

    it 'errors when invalid topic menu_group' do
      topic = create(:topic)
      model = build(:menu_group_published_entry_topic, topic: topic)
      expect(model.valid?).to be_falsy
    end

    it 'errors when invalid menu_group domain' do
      domain = create(:domain)
      published_entry = create(:published_entry, domain: domain)
      model = build(:menu_group_published_entry_topic, published_entry: published_entry)
      expect(model.valid?).to be_falsy
    end

  end
end
