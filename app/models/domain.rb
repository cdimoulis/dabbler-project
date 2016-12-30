# == Schema Information
#
# Table name: domains
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  subdomain   :string           not null
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Domain < ApplicationRecord

  default_scope { order(text: :asc) }

  has_many :groups
  has_many :featured_groups
  has_many :tutorial_groups
  has_many :topics

has_many :tutorial_groups
  validates :text, :subdomain, presence: true, uniqueness: true

end
