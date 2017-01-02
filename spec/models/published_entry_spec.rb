# == Schema Information
#
# Table name: published_entries
#
#  id               :uuid             not null, primary key
#  author_id        :uuid             not null
#  domain_id        :uuid             not null
#  group_id         :uuid             not null
#  topic_id         :uuid             not null
#  entry_id         :uuid             not null
#  image_url        :string
#  tags             :text             is an Array
#  publishable_id   :uuid
#  publishable_type :string
#  creator_id       :uuid             not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe PublishedEntry, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
