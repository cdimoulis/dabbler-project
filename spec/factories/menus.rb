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

FactoryGirl.define do

  factory :menu do
    text { "Menu #{Menu.count}" }
    description { "A description for #{text}" }
    domain { create(:domain) }
    domain_id { domain.id }
    order { Menu.count }
  end

end
