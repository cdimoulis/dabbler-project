# == Schema Information
#
# Table name: entries
#
#  id                :uuid             not null, primary key
#  text              :string           not null
#  description       :text
#  author_id         :uuid             not null
#  default_image_url :string
#  content           :text             not null
#  updated_entry_id  :uuid
#  locked            :boolean          default(FALSE)
#  remove            :boolean          default(FALSE)
#  creator_id        :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do

  factory :entry do
    text { "Entry #{Entry.count + 1}" }
    description 'Some great information about stuff'
    author { create(:user) }
    author_id { author.id }
    content "Here is some info to know about..."
    updated_entry nil
    updated_entry_id { updated_entry ? updated_entry.id : nil }

    factory :entry_with_creator do
      creator { author }
    end

    factory :entry_without_author do
      author nil
      author_id nil
      creator { create(:user) }
    end

  end
end
