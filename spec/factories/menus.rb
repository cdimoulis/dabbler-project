# == Schema Information
#
# Table name: menus
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  domain_id                :uuid             not null
#  order                    :integer
#  menu_group_ordering      :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryGirl.define do

  factory :menu do
    text { "Menu #{Menu.count}" }
    description { "A description for #{text}" }
    domain { create(:domain) }
    domain_id { domain.present? ? domain.id : nil }
    order { Menu.count }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil}
  end

end
