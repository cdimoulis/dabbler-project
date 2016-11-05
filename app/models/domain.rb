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

  has_many :domain_groups

  validates :text, :subdomain, presence: true, uniqueness: true

end
