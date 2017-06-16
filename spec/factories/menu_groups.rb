# == Schema Information
#
# Table name: menu_groups
#
#  id                       :uuid             not null, primary key
#  text                     :string           not null
#  description              :text
#  menu_id                  :uuid             not null
#  order                    :integer
#  topic_ordering           :text             default(["\"order:asc\"", "\"text:asc\""]), is an Array
#  published_entry_ordering :text             default(["\"published_at:desc\""]), is an Array
#  creator_id               :uuid             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryGirl.define do

  factory :menu_group do
    text { "Menu Group #{MenuGroup.count}" }
    description { "#{text.sub(' Group','')} test menu group" }
    menu { create(:menu, text: "Menu for #{text}") }
    menu_id { menu.present? ? menu.id : nil }
    order { MenuGroup.count }
    creator { create(:user) }
    creator_id { creator.present? ? creator.id : nil}
  end

end
