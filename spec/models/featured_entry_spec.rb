# == Schema Information
#
# Table name: published_entries
#
#  id         :uuid             not null, primary key
#  author_id  :uuid             not null
#  domain_id  :uuid             not null
#  entry_id   :uuid             not null
#  image_url  :string
#  notes      :text
#  tags       :text             is an Array
#  type       :string
#  data       :json
#  creator_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe FeaturedEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      featured_entry = create(:featured_entry)
      expect(featured_entry.type).to eq('FeaturedEntry')
    end
  end

  context 'validations' do
    it 'fails without published_at' do
      feat_entry = build(:featured_entry, data: {})
      expect(feat_entry.valid?).to be_falsy
    end
  end

  context 'test' do
    it 'sets topics' do
      feat_entry = create(:featured_entry)
      puts "\n\nGTPE: #{GroupTopicPublishedEntry.count}\n\n"
      puts "\n\nTOPICS: #{feat_entry.topics.count} - #{feat_entry.topics.pluck('id')}\n\n"
      puts "\n\nGROUPS: #{feat_entry.groups.count} - #{feat_entry.groups.pluck('id')}\n\n"
      puts "\n\nFE GTPE: #{feat_entry.group_topic_published_entries.count}\n\n"
      topic = create(:topic, domain: feat_entry.domain)
      topic_a = create(:topic, domain: feat_entry.domain)
      topic_b = create(:topic, domain: feat_entry.domain)
      feat_entry.topics << topic
      puts "\n\nGTPE count: #{GroupTopicPublishedEntry.count}\n\n"
      puts "\n\nTOPICS: #{feat_entry.topics.count} - #{feat_entry.topics.pluck('id')}\n\n"
      puts "\n\nGROUPS: #{feat_entry.groups.count} - #{feat_entry.groups.pluck('id')}\n\n"
      puts "\n\nFE GTPE: #{feat_entry.group_topic_published_entries.count}\n\n"
      feat_entry.topics = [topic, topic_a, topic_b]
      puts "\n\nGTPE count: #{GroupTopicPublishedEntry.count}\n\n"
      puts "\n\nTOPICS: #{feat_entry.topics.count} - #{feat_entry.topics.pluck('id')}\n\n"
      puts "\n\nGROUPS: #{feat_entry.groups.count} - #{feat_entry.groups.pluck('id')}\n\n"
      puts "\n\nFE GTPE: #{feat_entry.group_topic_published_entries.count}\n\n"
      group = create(:group, domain: feat_entry.domain)
      group_a = create(:group, domain: feat_entry.domain)
      group_b = create(:group, domain: feat_entry.domain)
      feat_entry.groups = [group_a, group_b]
      puts "\n\nGTPE count: #{GroupTopicPublishedEntry.count}\n\n"
      puts "\n\nTOPICS: #{feat_entry.topics.count} - #{feat_entry.topics.pluck('id')}\n\n"
      puts "\n\nGROUPS: #{feat_entry.groups.count} - #{feat_entry.groups.pluck('id')}\n\n"
      puts "\n\nFE GTPE: #{feat_entry.group_topic_published_entries.count}\n\n"
    end
  end
end
