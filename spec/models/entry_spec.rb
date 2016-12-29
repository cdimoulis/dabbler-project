# == Schema Information
#
# Table name: entries
#
#  id                :uuid             not null, primary key
#  text              :string           not null
#  description       :text
#  author_id         :uuid             not null
#  default_image_url :string
#  content           :text             not null
#  updated_entry_id  :uuid
#  locked            :boolean          default(FALSE)
#  remove            :boolean          default(FALSE)
#  creator_id        :uuid             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Entry, type: :model do

  context 'associations' do
    it { is_expected.to belong_to(:author) }
  end

  context '.save' do
    it 'succeeds' do
      entry = build(:entry_with_creator)
      expect(entry.save).to be_truthy
    end

    it 'requires a valid author' do
      entry = build(:entry_without_author)
      expect(entry.valid?).to be_falsy
      entry.author_id = "52af11a3-0527-454e-bab2-ded1dcdb4ac7"
      expect(entry.valid?).to be_falsy
    end
  end

end
