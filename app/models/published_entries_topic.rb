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

class PublishedEntriesTopic < ActiveRecord::Base
end
