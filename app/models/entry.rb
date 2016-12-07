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
#  remove            :boolean          default(FALSE)
#  creator_id        :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Entry < ActiveRecord::Base
  include HasCreator

  # has_and_belongs_to_many :contributors, class_name: 'User'

end
