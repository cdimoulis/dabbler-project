# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid             not null
#  topic_id           :uuid             not null
#  order              :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe PublishedEntriesTopic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:published_entry) }
    it { is_expected.to belong_to(:topic) }
  end

  context 'validations' do
    it 'succeeds normally' do
      pub_topic = build(:published_entries_topic)
      expect(pub_topic.valid?).to be_truthy
    end

    it 'fails without published_entry' do
      pub_topic = build(:published_entries_topic, published_entry: nil)
      expect(pub_topic.valid?).to be_falsy
    end

    it 'fails without topic' do
      pub_topic = build(:published_entries_topic, topic: nil)
      expect(pub_topic.valid?).to be_falsy
    end

    it 'fails if topic and published entry domain is different' do
      topic = create(:topic)
      published_entry = create(:published_entry)
      pub_topic = build(:published_entries_topic, published_entry: published_entry, topic: topic)
      expect(pub_topic.valid?).to be_falsy
    end

    it 'fails if duplicate published_entry topic combination' do
      topic = create(:topic)
      pe = create(:published_entry, domain: topic.domain)
      pub_topic = create(:published_entries_topic, topic: topic, published_entry: pe)
      dup = build(:published_entries_topic, topic: topic, published_entry: pe)
      expect(dup.valid?).to be_falsy
    end

    it 'failse if topic has duplicate order' do
      topic = create(:topic)
      pe = create(:published_entry, domain: topic.domain)
      pe1 = create(:published_entry, domain: topic.domain)
      pub_topic = create(:published_entries_topic, topic: topic, published_entry: pe, order: 1)
      dup = build(:published_entries_topic, topic: topic, published_entry: pe1, order: 1)
      expect(dup.valid?).to be_falsy
    end
  end

end
