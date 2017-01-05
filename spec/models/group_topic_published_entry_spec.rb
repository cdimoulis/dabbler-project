# == Schema Information
#
# Table name: group_topic_published_entries
#
#  id                 :uuid             not null, primary key
#  group_id           :uuid
#  topic_id           :uuid
#  published_entry_id :uuid
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe GroupTopicPublishedEntry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
