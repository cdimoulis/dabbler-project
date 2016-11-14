# == Schema Information
#
# Table name: admins
#
#  id                     :uuid             not null, primary key
#  email                  :string           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  person_id              :uuid             not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'
include FactoryGirl::Syntax::Methods

RSpec.describe Admin, type: :model do
  # pending "Admin tests"

  context 'associations' do
    it { is_expected.to belong_to(:person) }
  end

  context '.save' do
    it 'suceeds' do
      admin = build(:admin)
      expect(admin.save).to be_truthy
    end
  end
end
