# == Schema Information
#
# Table name: groups
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class DomainGroup < Group

  default_scope { order(text: :asc) }

  belongs_to :domain

  validates :text, :domain_id, presence: true
  validates :text, uniqueness: {scope: :domain_id, message: "Domain text must be unique"}
  validate :domain_exists


end
