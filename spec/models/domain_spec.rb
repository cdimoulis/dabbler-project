require "rails_helper"

RSpec.describe Domain do
  travel = Domain.where(text: "Travel").take

  context 'save new' do
    it 'empty domain should not work' do
      puts "\n\ntravel #{travel.inspect} \n\n"
      empty_domain = Domain.new()
      expect(empty_domain.save).to be_falsey
    end
  end
end
