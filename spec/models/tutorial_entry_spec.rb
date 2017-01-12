require 'rails_helper'

RSpec.describe TutorialEntry, type: :model do

  context 'inheritance' do
    it 'type is correct' do
      tutorial_entry = create(:tutorial_entry)
      expect(tutorial_entry.type).to eq('TutorialEntry')
    end
  end
end
