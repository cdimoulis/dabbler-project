# == Schema Information
#
# Table name: topics
#
#  id            :uuid             not null, primary key
#  text          :string           not null
#  description   :text
#  domain_id     :uuid             not null
#  menu_group_id :uuid             not null
#  creator_id    :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Topic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:menu_group) }
    it { is_expected.to belong_to(:creator) }
    it { expect(Topic.reflect_on_association(:published_entries).macro).to eq(:has_many)}
    it { expect(Topic.reflect_on_association(:published_entries).options[:through]).to eq(:menu_group_published_entry_topics)}
    # Appears to be an error in the shoulda matchers for have_many.through
    # it { is_expected.to have_many(:published_entries).through(:group_topic_published_entries) }

    it 'accesses published_entries' do
      topic = create(:topic)
      published_entry_a = create(:published_entry, domain: topic.domain)
      published_entry_b = create(:published_entry, domain: topic.domain)
      published_entry_c = create(:published_entry, domain: topic.domain)

      topic.published_entries << published_entry_b
      topic.published_entries << published_entry_c
      expect(topic.published_entries).to match([published_entry_b, published_entry_c])
      join = MenuGroupPublishedEntryTopic.where(topic_id: topic.id)
      expect(join.length).to eq(2)
    end
  end

  context 'validations' do
    let!(:topic) { build(:topic) }

    it 'requires valid domain' do
      topic.domain_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(topic.valid?).to be_falsy
    end

    it 'requires valid group' do
      topic.menu_group_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(topic.valid?).to be_falsy
    end

    it 'requires domain and group domain to be same' do
      domain = create(:domain)
      topic.domain_id = domain.id
      expect(topic.valid?).to be_falsy
    end

    it 'sets domain_id from group if nil' do
      d = build(:domain)
      topic = build(:topic_without_domain)
      expect(topic.valid?).to be_truthy
      expect(topic.domain_id).to eq(topic.menu_group.domain_id)
    end

    it 'does not allow duplicate text {scoped => :group}' do
      menu_group = create(:menu_group)
      topic_a = create(:topic, text: "My Topic", menu_group: menu_group, domain_id: menu_group.domain_id)
      topic_b = build(:topic, text: "My Topic", menu_group: menu_group, domain_id: menu_group.domain_id)
      expect(topic_b.valid?).to be_falsy
    end

    it 'allows duplicate text with different group' do
      menu_group_a = create(:menu_group)
      menu_group_b = create(:menu_group)
      topic_a = create(:topic, text: "My Topic", menu_group: menu_group_a, domain_id: menu_group_a.domain_id)
      topic_b = build(:topic, text: "My Topic", menu_group: menu_group_b, domain_id: menu_group_b.domain_id)
      expect(topic_b.valid?).to be_truthy
    end
  end

end
