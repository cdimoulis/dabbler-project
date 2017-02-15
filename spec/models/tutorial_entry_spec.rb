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
#  removed                    :boolean          default(FALSE)
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

    it "access groups" do
      tutorial_entry = create(:tutorial_entry)
      group_a = create(:tutorial_group, domain: tutorial_entry.domain)
      group_b = create(:tutorial_group, domain: tutorial_entry.domain)
      group_c = create(:tutorial_group, domain: tutorial_entry.domain)
      tutorial_entry.tutorial_groups << group_b
      tutorial_entry.groups << group_c

      expect(tutorial_entry.groups).to match([group_b, group_c])
      join = GroupTopicPublishedEntry.where(published_entry_id: tutorial_entry.id)
      expect(join.length).to eq(2)
    end
  end

  context 'validations' do
    it 'fails without order' do
      tut_entry = build(:tutorial_entry, data: {})
      expect(tut_entry.valid?).to be_falsy
    end
  end

  context 'scopes' do
    let!(:five) { create(:tutorial_entry, data: {order: 5}, created_at: (DateTime.now - 6.days).strftime) }
    let!(:four) { create(:tutorial_entry, data: {order: 4}, created_at: (DateTime.now - 7.days).strftime) }
    let!(:three) { create(:tutorial_entry, data: {order: 3}, created_at: (DateTime.now - 8.days).strftime) }
    let!(:two) { create(:tutorial_entry, data: {order: 2}, created_at: (DateTime.now - 9.days).strftime) }
    let!(:one) { create(:tutorial_entry, data: {order: 1}, created_at: (DateTime.now - 10.days).strftime) }

    it 'show current' do
      five.revised_published_entry_id = three.id
      five.save
      three.revised_published_entry_id = two.id
      three.save

      expect(TutorialEntry.current).to match([one,two,four])
    end
  end

  context '.destroy' do
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

    it 'destroys group_topic_published_entry' do
      tutorial_entry.groups << create(:tutorial_group, domain: tutorial_entry.domain)
      count = TutorialEntry.count
      join_count = GroupTopicPublishedEntry.count
      tutorial_entry.destroy
      expect(TutorialEntry.count).to eq(count-1)
      expect(GroupTopicPublishedEntry.count).to eq(join_count-1)
    end
  end
end
