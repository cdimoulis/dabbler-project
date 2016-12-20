# == Schema Information
#
# Table name: topics
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  group_id    :uuid             not null
#  creator_id  :uuid             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Topic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:domain) }
    it { is_expected.to belong_to(:group) }
  end

  context 'validations' do
    let!(:topic) { build(:topic) }

    it 'requires valid domain' do
      topic.domain_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(topic.valid?).to be_falsy
    end

    it 'requires valid group' do
      topic.group_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
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
      expect(topic.domain_id).to eq(topic.group.domain_id)
    end
  end

end
