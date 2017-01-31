# == Schema Information
#
# Table name: published_entries
#
#  id         :uuid             not null, primary key
#  author_id  :uuid             not null
#  domain_id  :uuid             not null
#  entry_id   :uuid             not null
#  image_url  :string
#  notes      :text
#  tags       :text             is an Array
#  type       :string
#  data       :json
#  creator_id :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TutorialEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      tutorial_entry = create(:tutorial_entry)
      expect(tutorial_entry.type).to eq('TutorialEntry')
    end
  end

  context 'validations' do
    it 'fails without order' do
      tut_entry = build(:tutorial_entry, data: {})
      expect(tut_entry.valid?).to be_falsy
    end
  end
end
