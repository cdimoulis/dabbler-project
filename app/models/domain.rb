# == Schema Information
#
# Table name: domains
#
#  id            :uuid             not null, primary key
#  text          :string           not null
#  description   :text
#  subdomain     :string           not null
#  active        :boolean          default(TRUE)
#  menu_ordering :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  creator_id    :uuid             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Domain < ApplicationRecord
  include SetCreator
  include Ordering

  default_scope { order(text: :asc) }

  has_many :menus
  has_many :menu_groups, through: :menus
  has_many :topics, through: :menu_groups
  has_many :published_entries
  has_many :featured_entries
  belongs_to :creator, class_name: "User"

  validates :text, :subdomain, presence: true
  validate :only_active_text, :only_active_subdomain

  ORDERING_CHILD = "Menu"

  protected

  # Only one active Domain can have the same text
  def only_active_text
    # All domain texts except this one
    texts = Domain.where(active: true).where.not(id: self.id).pluck('text')
    if texts.include?(text)
      errors.add(:text, 'Text must be unique among active Domains')
    end
  end

  # Only one active Domain can have the same subdomain
  def only_active_subdomain
    # All domain subdomains except this one
    subdomains = Domain.where(active: true).where.not(id: self.id).pluck('subdomain')
    if subdomains.include?(subdomain)
      errors.add(:subdomain, 'Subdomains must be unique among valid Domains')
    end
  end
end
