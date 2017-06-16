# == Schema Information
#
# Table name: published_entries_topics
#
#  id                 :uuid             not null, primary key
#  published_entry_id :uuid
#  topic_id           :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe PublishedEntriesTopic, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:published_entry) }
    it { is_expected.to belong_to(:topic) }
  end
  
end
