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



require "rails_helper"

RSpec.describe TutorialGroup do

  context 'inheritance' do
    it 'type is correct' do
      domain_group = create(:tutorial_group)
      expect(domain_group.type).to eq('TutorialGroup')
    end
  end
end
