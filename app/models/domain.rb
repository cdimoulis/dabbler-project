# == Schema Information
#
# Table name: domains
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  subdomain                :string           not null
#  active                   :boolean          default(TRUE)
#  menu_ordering            :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class Domain < ApplicationRecord
  include SetCreator
  include Ordering

  default_scope { order(text: :asc) }

  has_many :menus
  has_many :published_entries
  has_many :featured_entries
  belongs_to :creator, class_name: "User"

  validates :text, :subdomain, presence: true
  validate :only_active_text, :only_active_subdomain

  ORDERING_CHILD = "Menu"
  PUBLISHED_ENTRY_PARENTS = ['Menu', 'MenuGroup', 'Topic']

  protected

  # Only one active Domain can have the same text
  def only_active_text
    texts = Domain.where(active: true).pluck('text')
    if texts.include?(text)
      errors.add(:text, 'Text must be unique among valid Domains')
    end
  end

  # Only one active Domain can have the same subdomain
  def only_active_subdomain
    subdomains = Domain.where(active: true).pluck('subdomain')
    if subdomains.include?(subdomain)
      errors.add(:subdomain, 'Subdomains must be unique among valid Domains')
    end
  end
end
