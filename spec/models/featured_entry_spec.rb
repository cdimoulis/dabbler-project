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

RSpec.describe FeaturedEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      featured_entry = create(:featured_entry)
      expect(featured_entry.type).to eq('FeaturedEntry')
    end
  end
end
