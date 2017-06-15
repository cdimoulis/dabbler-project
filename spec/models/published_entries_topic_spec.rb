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
  pending "add some examples to (or delete) #{__FILE__}"
end
