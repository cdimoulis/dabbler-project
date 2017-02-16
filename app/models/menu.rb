# == Schema Information
#
# Table name: menus
#
#  id          :uuid             not null, primary key
#  text        :string           not null
#  description :text
#  domain_id   :uuid             not null
#  order       :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Menu < ActiveRecord::Base

  belongs_to :domain

  validates :text, uniqueness: {scope: :domain_id, message: "Menu text must be unique within a Domain"}
  validates :domain_id, presence: :true
  validates :order, uniqueness: {scope: :domain_id, message: "Menu order must be unique within a Domain"}

end
