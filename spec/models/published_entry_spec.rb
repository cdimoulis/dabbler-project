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
#  published_at               :datetime
#  type                       :string
#  revised_published_entry_id :uuid
#  removed                    :boolean          default(FALSE)
#  creator_id                 :uuid             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

require 'rails_helper'

RSpec.describe PublishedEntry, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:creator) }
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:entry) }
    it { is_expected.to belong_to(:revised_published_entry) }
    it { is_expected.to have_one(:previous_published_entry) }
    it { is_expected.to have_many(:published_entries_topics) }
    it { expect(PublishedEntry.reflect_on_association(:topics).macro).to eq(:has_many)}
    it { expect(PublishedEntry.reflect_on_association(:topics).options[:through]).to eq(:published_entries_topics)}

    it "accesses entry text" do
      published_entry = create(:published_entry)
      entry = Entry.first
      expect(published_entry.text).not_to eq(nil)
      expect(published_entry.text).to eq(entry.text)
    end

    it "access topics" do
      published_entry = create(:published_entry)
      menu_group = create(:menu_group, menu: create(:menu, domain: published_entry.domain))
      topic_a = create(:topic, menu_group: menu_group)
      topic_b = create(:topic, menu_group: menu_group)
      topic_c = create(:topic, menu_group: menu_group)
      published_entry.topics << topic_b
      published_entry.topics << topic_c

      expect(published_entry.topics).to match([topic_b, topic_c])
      join = PublishedEntriesTopic.where(published_entry_id: published_entry.id)
      expect(join.length).to eq(2)
    end

    it 'associates updated entries' do
      pe_a = create(:published_entry)
      pe_b = create(:published_entry)
      pe_c = create(:published_entry)
      pe_c.revised_published_entry = pe_b
      pe_c.save
      pe_b.revised_published_entry = pe_a
      pe_b.save
      expect(pe_a.revised_published_entry).to eq(nil)
      expect(pe_a.previous_published_entry).to eq(pe_b)
      expect(pe_b.revised_published_entry_id).to eq(pe_a.id)
      expect(pe_b.previous_published_entry).to eq(pe_c)
      expect(pe_c.revised_published_entry_id).to eq(pe_b.id)
    end
  end

  context 'validations' do
    let!(:published_entry) { build(:published_entry) }

    it 'is valid' do
      expect(published_entry.valid?).to be_truthy
    end

    it 'required author to match entry author' do
      user = create(:user)
      published_entry.author_id = user.id
      expect(published_entry.valid?).to be_falsy
    end

    it 'requires domain to exist' do
      published_entry.domain_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(published_entry.valid?).to be_falsy
    end

    it 'requires revision type match' do
      featured_entry = create(:featured_entry)
      tutorial_entry = build(:published_entry, revised_published_entry_id: featured_entry.id)
      expect(tutorial_entry.valid?).to be_falsy
    end
  end

  context 'scope' do
    let!(:a) { create(:published_entry) }
    let!(:b) { create(:published_entry) }
    let!(:c) { create(:published_entry) }

    it 'only shows current' do
      new_pe = create(:published_entry)
      a.revised_published_entry = new_pe
      a.save
      order = [b,c,new_pe]
      expect(PublishedEntry.current.order('created_at asc').to_a).to match(order)
    end

    it 'only shows non removed' do
      a.removed = true
      a.save
      order = [b,c]
      expect(PublishedEntry.non_removed.order('created_at asc').to_a).to match(order)
    end

    it 'only shows removed' do
      a.removed = true
      a.save
      order = [a]
      expect(PublishedEntry.removed.order('created_at asc').to_a).to match(order)
    end
  end

  context 'save' do
    it 'locks entry on creation' do
      entry = create(:entry)
      expect(entry.locked).to be_falsy
      published_entry = create(:published_entry, entry: entry)
      entry.reload
      expect(entry.locked).to be_truthy
    end
  end

  context 'destroy' do
    let!(:published_entry) { create(:published_entry) }

    it 'removes revised_published_entry_id from previous' do
      revised = create(:published_entry, revised_published_entry: published_entry)
      published_entry.destroy
      revised.reload
      expect(revised.revised_published_entry_id).to eq(nil)
    end

    it 'links previous and revised published entries' do
      revised = create(:published_entry, revised_published_entry: published_entry)
      previous = create(:published_entry, revised_published_entry: revised)
      revised.destroy
      previous.reload
      expect(previous.revised_published_entry_id).to eq(published_entry.id)
    end
  end
end
