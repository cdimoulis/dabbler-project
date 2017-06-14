# == Schema Information
#
# Table name: topics
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_group_id            :uuid             not null
#  order                    :integer
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require 'rails_helper'

RSpec.describe Topic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:menu_group) }
    it { is_expected.to belong_to(:creator) }
    it { expect(Topic.reflect_on_association(:published_entries).macro).to eq(:has_many)}
    it { expect(Topic.reflect_on_association(:published_entries).options[:through]).to eq(:menu_group_published_entry_topics)}
    # Appears to be an error in the shoulda matchers for have_many.through
    # it { is_expected.to have_many(:published_entries).through(:group_topic_published_entries) }

    it 'accesses published_entries' do
      topic = create(:topic)
      menu = topic.menu_group.menu
      published_entry_a = create(:published_entry, domain: menu.domain)
      published_entry_b = create(:published_entry, domain: menu.domain)
      published_entry_c = create(:published_entry, domain: menu.domain)

      topic.published_entries << published_entry_b
      topic.published_entries << published_entry_c
      expect(topic.published_entries).to match([published_entry_b, published_entry_c])
      join = MenuGroupPublishedEntryTopic.where(topic_id: topic.id)
      expect(join.length).to eq(2)
    end
  end

  context 'validations' do
    let!(:topic) { build(:topic) }

    it 'requires valid menu_group' do
      topic.menu_group_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(topic.valid?).to be_falsy
    end

    it 'does not allow duplicate text within same menu_group' do
      menu_group = create(:menu_group)
      topic_a = create(:topic, text: "My Topic", menu_group: menu_group)
      topic_b = build(:topic, text: "My Topic", menu_group: menu_group)
      expect(topic_b.valid?).to be_falsy
    end

    it 'allows duplicate text with different menu_group' do
      menu_group_a = create(:menu_group)
      menu_group_b = create(:menu_group)
      topic_a = create(:topic, text: "My Topic", menu_group: menu_group_a)
      topic_b = build(:topic, text: "My Topic", menu_group: menu_group_b)
      expect(topic_b.valid?).to be_truthy
    end

    context 'ordering' do
      it 'fails invalid published_entry_ordering' do
        menu_group = build(:menu_group, published_entry_ordering: ['text', 'order', 'Menu'])
        expect(menu_group.valid?).to be_falsy
      end
    end
  end

  context 'scope' do
    context 'ordering concern' do
      let!(:a) { create(:topic, text: 'A', order: nil) }
      let!(:b) { create(:topic, text: 'B', order: nil) }
      let!(:c) { create(:topic, text: 'C', order: 3) }
      let!(:d) { create(:topic, text: 'D', order: 2) }
      let!(:e) { create(:topic, text: 'E', order: 1) }
      let!(:f) { create(:topic, text: 'F', order: nil) }
      let!(:menu_group) { create(:menu_group) }

      it 'orders with menu_group default ordering' do
        ordered = [e,d,c,a,b,f]
        expect(Topic.ordering_scope(menu_group).to_a).to match(ordered)
      end

      it 'orders with menu_group reverse ordering' do
        menu_group.update_attribute(:topic_ordering, ['order:desc','text:desc'])
        ordered = [c,d,e,f,b,a]
        expect(Topic.ordering_scope(menu_group).to_a).to match(ordered)
      end

      it 'orders correctly with text first' do
        menu_group.update_attribute(:topic_ordering, ['text:asc','order:asc'])
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [a,b,c,d,e,f]
        expect(Topic.ordering_scope(menu_group).to_a).to match(ordered)
      end

      it 'orders correctly with all order' do
        f.update_attribute(:order, 4)
        b.update_attribute(:order, 5)
        a.update_attribute(:order, 6)
        ordered = [e,d,c,f,b,a]
        expect(Topic.ordering_scope(menu_group).to_a).to match(ordered)
      end

      it 'orders correctly with no order' do
        c.update_attribute(:order, nil)
        d.update_attribute(:order, nil)
        e.update_attribute(:order, nil)
        ordered = [a,b,c,d,e,f]
        expect(Topic.ordering_scope(menu_group).to_a).to match(ordered)
      end
    end
  end

end
